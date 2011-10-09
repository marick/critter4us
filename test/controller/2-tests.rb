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
      real_controller.test_view_builder = @dummy_view
      get Href.note_editing_page(@reservation)
      assert { @dummy_view[:reservation] == @reservation }
    end

    should "upon post, should update reservation's note" do
      post Href.note_editing_page(@reservation), "note" => "new text"
      assert { Reservation[:note => "new text"].id == @reservation.id }
      assert_redirect_to(Href.note_editing_page(@reservation))
    end
  end
end
