require './test/testutil/requires'
require './strangled-src/model/requires'
require './src/views/requires'

class HelperTests < FreshDatabaseTestCase
  include Helpers::Reservation
  should  "know how to display time of day" do
    morning = Reservation.random(:timeslice => Timeslice.random(:times => [MORNING]))
    afternoon = Reservation.random(:timeslice => Timeslice.random(:times => [MORNING, AFTERNOON]))
    evening = Reservation.random(:timeslice => Timeslice.random(:times => [MORNING, AFTERNOON, EVENING]))

    assert_equal('morning', time_of_day(morning))
    assert { 'morning, afternoon' == time_of_day(afternoon) }
    assert { 'morning, afternoon, evening' == time_of_day(evening) }
  end
end
