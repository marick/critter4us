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

    should "upon get, should pass the reservation to a view" do
      during { 
        get '/2/reservation/200/note'
      }.behold! {
        @reservation_source.should_receive(:[]).once.
                            with(200).
                            and_return(@expected_reservation)
      }

      assert { @dummy_view[:reservation] == @expected_reservation }
    end
  end
end
