require './test/testutil/requires'
require './src/routes/base'
require 'ostruct'
require './src/db/full_reservation'
require './src/functional/functionally'
require './strangled-src/model/requires'

class ReservationResourceTest < RackTestTestCase
  include JsonHelpers

  def setup
    super
    real_controller.override(mocks(:renderer))
    @renderer.should_receive(:render_textile, :render_page).zero_or_more_times.
              with_any_args.by_default
    @reservation = Reservation.random
  end

  context "adding notes to reservations" do
    context "PUT" do 
      should "update the reservation's note" do
        put Href::Reservation.note_generator(@reservation.id), "note" => "new text"
        assert { Reservation[:note => "new text"].id == @reservation.id }
      end

      should "return the note as Textile html" do
        during { 
          put Href::Reservation.note_generator(@reservation.id), "note" => "**new**"
        }.behold! {
          @renderer.should_receive(:render_textile).once.with("**new**")
        }
      end
    end
  end

  context "making a repetition of a reservation" do

    def stash_reservation(*groups)
      constant_data = {
        :timeslice => Timeslice.new(Date.new(2009, 7, 13),
                                    Date.new(2009, 7, 14),
                                    TimeSet.new(MORNING)),
        :course => 'vm333',
        :instructor => 'morin',
      }
      data = constant_data.merge(:groups => groups)
      ReservationMaker.build_from(data)
    end

    def with_captured_json_data
      captured = nil
      during {
        yield
      }.behold! {
        @renderer.should_receive(:render_json).once.
                  with(on { | arg | captured = arg; true })
      }
      captured
    end

    should "just copy data in the ideal case" do
      procedure = Procedure.random(:name => "procedure")
      animal = Animal.random(:name => "animal")

      existing_id = stash_reservation({:procedures => ['procedure'],
                                       :animals => ['animal']}).id

      captured = with_captured_json_data do 
        put Href::Reservation.repetitions_generator(existing_id), "day_shift" => "7"
      end

      deny { captured.reservation_id == existing_id }
      original_reservation = FullReservation.from_id(existing_id)
      new_reservation = FullReservation.from_id(captured.reservation_id)
      assert { new_reservation.data.instructor == "morin" }
      assert { FunctionalTimeslice.from_reservation(new_reservation) == 
               FunctionalTimeslice.from_reservation(original_reservation).shift_by_days(7) }

      assert { new_reservation.animal_names == ["animal"] }
      assert { new_reservation.procedure_names == ["procedure"] }

      expected_json = {
        animals_already_in_use: [],
        blacked_out_use_pairs: [],
        reservation_id: captured.reservation_id
      }
      assert { captured == expected_json }
    end
    
=begin

        :groups => [ {:procedures => ['procedure 1'],
                       :animals => [@animal1.name, @animal2.name] }, 
                     {:procedures => ['procedure 2'],
                       :animals => [@animal1.name, @animal2.name, @animal3.name] } ]

      @animal1 = Animal.random(:name => "animal 1 - in use")
      @animal2 = Animal.random(:name => "animal 2 - blackout with procedure 2")
      @animal3 = Animal.random(:name => "animal 3")
      @procedure1 = Procedure.random(:name => "procedure 1")
      @procedure2 = Procedure.random(:name => "procedure 2")


        old_style = ReservationMaker.build_from(data)

        new_timeslice = {
          :first_date => Date.new(2010, 1, 1),
          :last_date => Date.new(2010, 2, 2),
          :times => ["morning"]
        }
    end

        # ExcludedBecauseInUse.insert(:first_date => new_timeslice[:first_date],
        #                             :last_date => new_timeslice[:first_date],
        #                             :time_bits => "100",
        #                             :animal_id => animal1.id)
        # ExcludedBecauseOfBlackoutPeriod.insert(:first_date => new_timeslice[:last_date],
        #                                        :last_date => new_timeslice[:last_date]+10,
        #                                        :time_bits => "111",
        #                                        :animal_id => animal2.id,
        #                                        :procedure_id => procedure2.id)

        data_to_render = nil
        during { 
          post Href::Reservation.repetitions_generator(old_style.id),
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
=end
  end
end
