$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class UseTests < FreshDatabaseTestCase
  should "be able to select uses happening at a particular moment" do
    matching_animal =  Animal.random(:name => "inuse")
    matching_procedure = Procedure.random(:name => 'inuse')
    Reservation.random(:date => Date.new(2009, 9, 9),
                       :time => MORNING) do
      use matching_animal
      use matching_procedure
    end
    Reservation.random(:date => Date.new(2009, 9, 9),
                       :time => AFTERNOON) do
      use Animal.random(:name => "afternoon")
      use Procedure.random(:name => 'afternoon')
    end
    Reservation.random(:date => Date.new(2009, 9, 10),
                       :time => MORNING) do
      use Animal.random(:name => "wrong date")
      use Procedure.random(:name => 'wrong date')
    end

    result = Use.at(Date.new(2009, 9, 9), MORNING) 
    assert { result.length == 1 }
    assert { result[0].animal == matching_animal }
    assert { result[0].procedure == matching_procedure }
  end
end
