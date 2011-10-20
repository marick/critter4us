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
    should "upon get, should pass the reservation to a view" do
      during {
        get Href.note_editing_page(@reservation)
      }.behold! {
        @renderer.should_receive(:render_page).once.
                  with(:get_note_editing_page, :reservation => @reservation)
      }
    end
  end

  context "scheduling further reservations by example" do
    should "upon get, produce a page containing the reservation" do 
      during {
        get Href.schedule_reservations_page(@reservation)
      }.behold! {
        @renderer.should_receive(:render_page).once.
        with(:get_reservation_scheduling_page, :reservation => @reservation)
      }
    end
  end

  context "posting a new note" do

    should "update the reservation's note" do
      post Href.note_editing_page(@reservation), "note" => "new text"
      assert { Reservation[:note => "new text"].id == @reservation.id }
    end

    should "return the note as Textile html" do
      during { 
        post Href.note_editing_page(@reservation), "note" => "**new**"
      }.behold! {
        @renderer.should_receive(:render_textile).once.with("**new**")
      }
    end
  end
end
