require './test/testutil/requires'
require './controller/base'
require 'ostruct'

class NewControllerTests < RackTestTestCase
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
        get Href.note_editing_page(@reservation.id)
      }.behold! {
        @renderer.should_receive(:render_page).once.
                  with(:get_note_editing_page, :reservation => @reservation)
      }
    end

    context "POST" do 
      should "update the reservation's note" do
        post Href.note_editing_page(@reservation.id), "note" => "new text"
        assert { Reservation[:note => "new text"].id == @reservation.id }
      end

      should "return the note as Textile html" do
        during { 
          post Href.note_editing_page(@reservation.id), "note" => "**new**"
        }.behold! {
          @renderer.should_receive(:render_textile).once.with("**new**")
        }
      end
    end
  end

  context "scheduling further reservations by example" do
    should "GET produces a page containing the reservation" do 
      during {
        get Href.schedule_reservations_page(@reservation.id)
      }.behold! {
        @renderer.should_receive(:render_page).once.
        with(:get_reservation_scheduling_page, :reservation => @reservation)
      }
    end

    should_eventually "POST should coordinate other objects" do
      real_controller.override(mocks(:internalizer, :externalizer,
                                     :availability_source, :reservation_source))
      availability = flexmock("availability")
      reservation = flexmock("reservation")
      during {
        post Href.schedule_reservations_page("id"),
             :timeslice=>"timeslice representation"
      }.behold! {
        @internalizer.should_receive(:make_timeslice).once.
                      with("timeslice representation").
                      and_return("timeslice")
        @availability_source.should_receive(:new).once.
                             with("timeslice").
                             and_return(availability)

        @reservation_source.should_receive(:[]).once.
                            with("id").
                            and_return(reservation)

        availability.should_receive(:trim_conflicting_uses).once.
                      with(reservation)
        reservation.should_receive(:save_as_copy).once
        reservation.should_receive(:trimmed_animals).once.
                     and_return(["animals"])
        @externalizer.should_receive(:convert).once.
                     with({'omitted_animals' => ["animals"]}).
                     and_return("json")
      }
      assert_json_response
      assert_jsonification_of("json")
    end
  end
  
end
