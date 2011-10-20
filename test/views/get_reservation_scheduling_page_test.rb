require './test/testutil/requires'
require './model/requires'
require './views/requires'

class GetReservationSchedulingPageTest < ViewTestCase

  def render(hash)
    reservation = Reservation.random(hash)
    @renderer.render_page(:get_reservation_scheduling_page, :reservation => reservation)
  end

  should "use reservation to populate page upon GET" do
    assert { render(:instructor => 'Dr. Dawn')['Dr. Dawn'] }
  end

end
