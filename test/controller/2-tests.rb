require './test/testutil/requires'
require './controller/base'
require 'ostruct'

class NewControllerTests < RackTestTestCase
  def setup
    super
    @dummy_view = TestViewClass.new
  end

  context "adding notes to reservations" do
    setup do
      @reservation = Reservation.random
    end

    should "upon get, should pass the reservation to a view" do
      real_controller.override(mocks(:renderer))
      during {
        get Href.note_editing_page(@reservation)
      }.behold! {
        @renderer.should_receive(:render_page).once.
                  with(:get_note_editing_page, :reservation => @reservation)
      }
    end

    context "posting a new note" do

      should "upon post, should update reservation's note" do
        post Href.note_editing_page(@reservation), "note" => "new text"
        assert { Reservation[:note => "new text"].id == @reservation.id }
      end

      should "return the note as html" do
        post Href.note_editing_page(@reservation), "note" => "**new**"
        assert { last_response.body =~ /<b>new<\/b>/ }
      end
    end
  end

end
