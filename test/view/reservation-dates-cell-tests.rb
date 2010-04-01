$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ReservationDatesCellWidgetTests < FreshDatabaseTestCase
  include ViewHelper

  context "single-day reservations" do 
    setup do 
      @reservation = Reservation.random(:first_date => Date.new(2010, 1, 1),
                                                   :last_date => Date.new(2010, 1, 1))
      @html = ReservationDatesCell.new(:reservations => [@reservation]).to_s
    end
    
    should "include dates in its output" do 
      assert { @html.include? "2010-01-01" }
    end

    should "include a link to the reservation" do 
      reservation = @reservation
      assert_xhtml(@html) do
        a('2010-01-01', :href => %r{reservation/#{reservation.pk}})
      end
    end
  end


  context "multi-day reservations" do 
    setup do 
      @reservation = Reservation.random(:first_date => Date.new(2019, 12, 13),
                                                  :last_date => Date.new(2019, 12, 14))
      @html = ReservationDatesCell.new(:reservations => [@reservation]).to_s
    end
    
    should "include dates in its output" do 
      assert { @html.include? "2019-12-13 to 2019-12-14" }
    end

    should "include a link to the reservation" do 
      reservation = @reservation
      assert_xhtml(@html) do
        a('2019-12-13 to 2019-12-14', :href => %r{reservation/#{reservation.pk}})
      end
    end
  end

end
