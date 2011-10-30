require './test/testutil/requires'
require './src/routes/base'
require 'ostruct'

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
      should_eventually "coordinate other objects" do
        real_controller.override(mocks(:internalizer2, :renderer, :functionally))
        during {
          post Href.schedule_reservations_page("id"),
               :timeslice=>"timeslice representation"
        }.behold! {
          @internalizer2.should_receive(:maplike_timeslice).once.
                         with("timeslice representation").
                         and_return("timeslice")
          @functionally.should_receive(:shift_to_timeslice).once.
                        with("id", "timeslice").
                        and_return(["animal names"])
          @renderer.should_receive(:render_json).once.
                    with(:omitted_animals => ["animal names"])
        }
        assert_json_response
      end
    end
  end
  
end
