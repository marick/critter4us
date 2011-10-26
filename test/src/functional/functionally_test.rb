require './src/db/full_reservation'
require './strangled-src/util/test-support'

class FunctionallyCodingTests < FreshDatabaseTestCase
  should_eventually "be able to copy reservations" do
    r = Reservation.random(:animal => Animal.random(:name => "animal"),
                           :procedure => Procedure.random(:name => "procedure"))

    
  end
end
