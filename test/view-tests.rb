require 'test/testutil/requires'
require 'view'

class ViewTests < Test::Unit::TestCase
  context "reservation display" do
    should "know how to display time of day" do
      morning = Reservation.create(:morning => true)
      morning_view = ReservationView.new(:reservation => morning)
      
      afternoon = Reservation.create(:morning => false)
      afternoon_view = ReservationView.new(:reservation => afternoon)

      assert { 'morning' == morning_view.time_of_day }
      assert { 'afternoon' == afternoon_view.time_of_day }
    end

    should "include session information in output" do
      expected_date = '2009-09-03'
      expected_morning = "morning"
      expected_instructor = "d-morin"
      expected_course = "vm333"
      reservation = Reservation.create(:date => expected_date,
                                       :morning => true,
                                       :instructor => expected_instructor,
                                       :course => expected_course)
      actual = ReservationView.new(:reservation => reservation).to_s
      assert { actual.include?(expected_date) }
      assert { actual.include?(expected_morning) }
      assert { actual.include?(expected_instructor) }
      assert { actual.include?(expected_course) }
    end
  end
end

