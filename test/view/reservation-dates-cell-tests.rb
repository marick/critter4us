$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ReservationDatesCellWidgetTests < FreshDatabaseTestCase
  include ViewHelper

  def setup
    @reservation = Reservation.random(:date => Date.new(2019, 12, 13))
    @html = ReservationDatesCell.new(:reservations => [@reservation]).to_s
  end
  
  should "include dates in its output" do 
    assert { @html.include? "2019-12-13" }
  end

  should "include a link to the reservation" do 
    reservation = @reservation
    assert_xhtml(@html) do
        a('2019-12-13', :href => %r{reservation/#{reservation.pk}})
    end
  end

  
end
