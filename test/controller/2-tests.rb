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
      real_controller.override(mocks(:reservation_source))
      real_controller.test_view_builder = @dummy_view
      @expected_reservation = Reservation.random
    end

    should "upon get, should pass the reservation number to a view" do
      get '/2/reservation/200/note'
      assert { @dummy_view[:reservation_id] == "200" }
    end
  end
end
