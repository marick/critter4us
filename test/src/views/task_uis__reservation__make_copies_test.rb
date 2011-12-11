require './test/testutil/requires'
require './strangled-src/model/requires'
require './src/views/requires'

class GetReservationSchedulingPageTest < ViewTestCase

  def render(hash)
    reservation = Reservation.random(hash)
    @renderer.render_page(:task_uis__reservation__make_copies, :reservation => reservation)
  end

  should "use reservation to populate page upon GET" do
    assert { render(:instructor => 'Dr. Dawn')['Dr. Dawn'] }
  end

end
