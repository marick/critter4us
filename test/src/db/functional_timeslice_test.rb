require './test/testutil/requires'
require './src/db/functional_timeslice'
require './src/db/full_reservation'
require 'base64'
require 'json'

class FunctionalTimesliceTest < FreshDatabaseTestCase

  should "convert in from_browser format" do
    original = {
      :first_date => "2009-7-23",
      :last_date => "2010-8-24",
      :times => ["morning"]
    }
    encoded = Base64.encode64(original.to_json)
    timeslice = FunctionalTimeslice.from_browser(encoded)
    assert { timeslice.first_date == Date.new(2009, 7, 23) }
    assert { timeslice.last_date == Date.new(2010, 8, 24) }
    assert { timeslice.time_bits == "100" }
  end

  should "read from reservation" do 
    old_format = Reservation.random(:timeslice => Timeslice.new(Date.new(2009, 7, 23),
                                                                Date.new(2009, 8, 24),
                                                                TimeSet.new(AFTERNOON)))
    new_format = FullReservation.from_id(old_format.id)
    
    timeslice = FunctionalTimeslice.from_reservation(new_format)
    assert { timeslice.first_date == Date.new(2009, 7, 23) }
    assert { timeslice.last_date == Date.new(2009, 8, 24) }
    assert { timeslice.time_bits == "010" }
  end
end
