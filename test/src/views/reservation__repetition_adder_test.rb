require './test/testutil/requires'
require './strangled-src/model/requires'
require './src/views/requires'

class GetRepetitionAddingPageTest < ViewTestCase

  def render(hash)
    reservation = Reservation.random(hash)
    @renderer.render_page(:reservation__repetition_adder, :reservation => reservation)
  end

  should "use reservation to populate page upon GET" do
    assert { render(:instructor => 'Dr. Dawn')['Dr. Dawn'] }
  end

end
