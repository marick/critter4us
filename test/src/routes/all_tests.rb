require './test/testutil/requires'
require './src/routes/base'
require 'ostruct'
require './src/db/full_reservation'
require './src/functional/functionally'
require './strangled-src/model/requires'

# Migrate these toward end-to-end tests instead of mock tests?

class NewControllerTests < RackTestTestCase
  include JsonHelpers

  def setup
    super
    @dummy_view = TestViewClass.new
    real_controller.override(mocks(:renderer))
    @renderer.should_receive(:render_textile, :render_page).zero_or_more_times.
              with_any_args.by_default
    @reservation = Reservation.random
  end

  context "adding notes to reservations" do
    should "GET should pass the reservation to a view" do
      during {
        get Href.reservation_note(@reservation.id)
      }.behold! {
        @renderer.should_receive(:render_page).once.
                  with(:reservation_note__editing, :reservation => @reservation)
      }
    end

    context "POST" do 
      should "update the reservation's note" do
        post Href.reservation_note(@reservation.id), "note" => "new text"
        assert { Reservation[:note => "new text"].id == @reservation.id }
      end

      should "return the note as Textile html" do
        during { 
          post Href.reservation_note(@reservation.id), "note" => "**new**"
        }.behold! {
          @renderer.should_receive(:render_textile).once.with("**new**")
        }
      end
    end
  end

  context "scheduling further reservations by example" do
    context "GET" do 
      should "produce a page containing the reservation" do 
        during {
          get Href.schedule_reservations_page(@reservation.id)
        }.behold! {
          @renderer.should_receive(:render_page).once.
          with(:get_reservation_scheduling_page, :reservation => @reservation)
        }
      end
    end

    context "POST" do 
      should "be able to copy reservations" do
        animal1 = Animal.random(:name => "animal 1 - in use")
        animal2 = Animal.random(:name => "animal 2 - blackout with procedure 2")
        animal3 = Animal.random(:name => "animal 3")
        procedure1 = Procedure.random(:name => "procedure 1")
        procedure2 = Procedure.random(:name => "procedure 2")
        data = {
          :timeslice => Timeslice.new(Date.new(2009, 7, 23),
                                      Date.new(2009, 8, 24),
                                      TimeSet.new(MORNING)),
          :course => 'vm333',
          :instructor => 'morin',
          :groups => [ {:procedures => ['procedure 1'], :animals => [animal1.name, animal2.name] }, 
                       {:procedures => ['procedure 2'], :animals => [animal1.name, animal2.name, animal3.name] } ]
        }
        old_style = ReservationMaker.build_from(data)

        new_timeslice = {
          :first_date => Date.new(2010, 1, 1),
          :last_date => Date.new(2010, 2, 2),
          :times => ["morning"]
        }

        ExcludedBecauseInUse.insert(:first_date => new_timeslice[:first_date],
                                    :last_date => new_timeslice[:first_date],
                                    :time_bits => "100",
                                    :animal_id => animal1.id)
        ExcludedBecauseOfBlackoutPeriod.insert(:first_date => new_timeslice[:last_date],
                                               :last_date => new_timeslice[:last_date]+10,
                                               :time_bits => "111",
                                               :animal_id => animal2.id,
                                               :procedure_id => procedure2.id)

        data_to_render = nil
        during { 
          post Href.schedule_reservations_page_route(old_style.id),
                    "timeslice" => Base64.encode64(new_timeslice.to_json)
        }.behold! { 
          @renderer.should_receive(:render_json).once.
          with(on { | arg | data_to_render = arg; true })
        }

        assert { data_to_render.size == 3 }
        assert { data_to_render.animals_already_in_use == [animal1.name] }
        assert { data_to_render.blacked_out_use_pairs == [ {:animal_name => animal2.name,
                                                     :procedure_name => procedure2.name }] }
        # The reservation is the new one. 
        from_disk = FullReservation.from_id(data_to_render.reservation_id)
        deny { from_disk.uses.any? { | use | use.animal_name == animal1.name } } 
        deny { from_disk.uses.any? { | use | 
            use.animal_name == animal2.name && use.procedure_name == procedure2.name
          }}

        # But the other two remain
        assert { from_disk.uses.any? { | use | 
            use.animal_name == animal2.name && use.procedure_name == procedure1.name
          }}
        assert { from_disk.uses.any? { | use | 
            use.animal_name == animal3.name && use.procedure_name == procedure2.name
          }}
      end
    end
  end
end
