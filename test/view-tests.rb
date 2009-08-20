$: << '..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view'
require 'assert2/xhtml'

class ViewTests < Test::Unit::TestCase
  context "reservation display" do
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
  end

  context "reservation list display" do
    should "sort reservations" do
      earlier = Reservation.random(:date => Date.new(2008, 8, 8))
      afternoon = Reservation.random(:date => Date.new(2009, 9, 9),
                                   :morning => false)
      morning = Reservation.random(:date => Date.new(2009, 9, 9),
                                   :morning => true)

      view = ReservationListView.new(:reservations => [afternoon, morning, earlier])
      assert { [earlier, morning, afternoon] == view.sorted_reservations }
    end

    should "display contents from each reservation" do
      first = Reservation.random(:course => 'v=m=1')
      second = Reservation.random(:course => 'v=m=2')

      output = ReservationListView.new(:reservations => [first, second]).to_s
      assert { /v=m=1/ =~ output }
      assert { /v=m=2/ =~ output }
    end

    should "display entirety of reservation" do
      reservation = Reservation.random(:morning => false) do
        use Animal.random
        use Procedure.random
      end

      r = lambda { | string | Regexp.new(Regexp.escape(string)) }

      output = ReservationListView.new(:reservations => [reservation]).to_s
      assert { r[reservation.instructor] =~ output }
      assert { r[reservation.course] =~ output }
      assert { r[reservation.date.to_s] =~ output }
      assert { r['afternoon'] =~ output }
      assert { r[reservation.uses[0].animal.name] =~ output }
      assert { r[reservation.uses[0].procedure.name] =~ output }
    end

    should "know how to display time of day" do
      morning = Reservation.random(:morning => true)
      morning_view = ReservationView.new(:reservation => morning)
      
      afternoon = Reservation.random(:morning => false)
      afternoon_view = ReservationView.new(:reservation => afternoon)

      assert { 'morning' == morning_view.time_of_day(morning) }
      assert { 'afternoon' == afternoon_view.time_of_day(afternoon) }
    end

    should "contain well-formed delete button" do
      reservation = Reservation.random(:course => 'v=m=1')

      output = ReservationListView.new(:reservations => [reservation]).to_s
      assert_xhtml(output) do
        td do
          form :method => 'POST',
               :action => "reservation/#{reservation.id}" do 
            input(:type => 'hidden', :value => "DELETE", :name => "_method")
            input(:type => 'submit')
          end
        end
      end
    end

  end
end

