$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ReservationViewTests < Test::Unit::TestCase
  should "include session information in output" do
    expected_date = '2009-09-03'
    expected_morning = "morning"
    expected_instructor = "d-morin"
    expected_course = "vm333"
    reservation = Reservation.random(:date => expected_date,
                                     :morning => true,
                                     :instructor => expected_instructor,
                                     :course => expected_course)
    actual = ReservationView.new(:reservation => reservation).to_s
    assert { actual.include?(expected_date) }
    assert { actual.include?(expected_morning) }
    assert { actual.include?(expected_instructor) }
    assert { actual.include?(expected_course) }
  end

  should "know how to display time of day" do
    morning = Reservation.random(:morning => true)
    morning_view = ReservationView.new(:reservation => morning)
    
    afternoon = Reservation.random(:morning => false)
    afternoon_view = ReservationView.new(:reservation => afternoon)

    assert { 'morning' == morning_view.time_of_day(morning) }
    assert { 'afternoon' == afternoon_view.time_of_day(afternoon) }
  end
end

