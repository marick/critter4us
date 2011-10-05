require './test/testutil/requires'
require './model/requires'
require './view/requires'

class ReservationDatesCellWidgetTests < FreshDatabaseTestCase
  include ViewHelper
  include HtmlAssertions

  context "single-day reservations" do 
    setup do 
      @reservation = Reservation.random(:timeslice =>
                                        Timeslice.random(:first_date => '2010-01-01',
                                                         :last_date => '2010-01-01'))
      @html = ReservationDatesCell.new(:reservations => [@reservation]).to_html
    end
    
    should "include dates in its output" do 
      assert { @html.include? "2010-01-01" }
    end

    should "include a link to the reservation" do 
      reservation = @reservation
      assert_text_has_selector(@html, "a", :text => '2010-01-01')
      assert_text_has_attributes(@html, "a", :href => %r{reservation/#{reservation.pk}})
      # assert_xhtml(@html) do
      #   a('2010-01-01', :href => %r{reservation/#{reservation.pk}})
      # end
    end
  end


  context "multi-day reservations" do 
    setup do 
      @reservation = Reservation.random(:timeslice => 
                                        Timeslice.random(:first_date => '2019-12-13',
                                                         :last_date => '2019-12-14'))
      @html = ReservationDatesCell.new(:reservations => [@reservation]).to_html
    end
    
    should "include dates in its output" do 
      assert { @html.include? "2019-12-13 to 2019-12-14" }
    end

    should "include a link to the reservation" do 
      reservation = @reservation
      assert_text_has_selector(@html, "a", :text => '2019-12-13 to 2019-12-14')
      assert_text_has_attributes(@html, "a", :href => %r{reservation/#{reservation.pk}})
      # assert_xhtml(@html) do
      #   a('2019-12-13 to 2019-12-14', :href => %r{reservation/#{reservation.pk}})
      # end
    end
  end

end
