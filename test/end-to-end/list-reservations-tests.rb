require './test/testutil/requires'

class ListReservationTestCase < EndToEndTestCase

  def setup
    super
    Procedure.random(:name => 'venipuncture')
    Animal.random(:name => 'veinie')

    @earlier = Date.today - 31

    make_reservation(@earlier, %w{veinie}, %w{venipuncture})
  end

  def show_many_reservations
    get '/reservations/gazillion'
    assert_body_has_selector('td', :text => "veinie")
    assert_body_has_selector('td', :text => "venipuncture")
  end

  def show_no_reservations
    get '/reservations/30'
    deny { last_response.body.include?("veinie") }
    deny { last_response.body.include?("venipuncture") }
  end

  should "do end-to-end trip" do 
    show_many_reservations
    show_no_reservations
  end
end
