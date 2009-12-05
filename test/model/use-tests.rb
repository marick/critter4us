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


  context "returning animals in use" do
    setup do 
      @date = Date.new(2010, 10, 10)
      @time = MORNING
      @fred = Animal.random(:name => "fred")
      @unused = Animal.random(:name => "will not appear")
    end

    should "include animals in use at the exact moment" do 
      fred = @fred; unused = @unused
      Reservation.random(:date => @date, :time => @time) do
        use fred
        use Procedure.random
      end
      Reservation.random(:date => @date, :time => EVENING) do
        use unused
        use Procedure.random
      end
      Reservation.random(:date => @date+1, :time => @time) do 
        use unused
        use Procedure.random
      end

      assert_equal([@fred], Use.animals_in_use_at(@date, @time))
    end
  end



end
