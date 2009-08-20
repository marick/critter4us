$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ReservationModelTests < Test::Unit::TestCase
  def setup
    empty_tables
  end

  should "can create a single 'nested' uses" do
    Procedure.random(:name => 'procedure')
    Animal.random(:name => 'animal')
    
    test_data = {
      :instructor => 'marge',
      :course => 'vm333',
      :date => Date.new(2001, 2, 4),
      :morning => true,
      :procedures => ['procedure'],
      :animals => ['animal'],
    }
    reservation = Reservation.create_with_uses(test_data)
    test_data.keys.each do | key | 
      next if key == :procedures || key == :animals
      assert { reservation.send(key) == test_data[key] }
    end

    assert { reservation.uses.size == 1 }
    use = reservation.uses[0]
    assert { use.animal.name == 'animal' }
    assert { use.procedure.name == 'procedure' }
    assert { use.reservation == reservation }
  end

  context "multiple animals and procedures" do 

    setup do
      @p1 = Procedure.random(:name => 'p1')
      @p2 = Procedure.random(:name => 'p2')
      @a1 = Animal.random(:name => 'a1')
      @a2 = Animal.random(:name => 'a2')
      test_data = {
        :instructor => 'marge',
        :course => 'vm333',
        :date => Date.new(2001, 2, 4),
        :morning => false,
        :procedures => ['p1', 'p2'],
        :animals => ['a1', 'a2'],
      }
      @reservation = Reservation.create_with_uses(test_data)
    end

    should "can create the cross-product of procedures and animals" do
      deny { @reservation.morning}
      assert { Use.all.size == 4 }
      assert { Use[:procedure_id => @p1.id, :animal_id => @a1.id] } 
      assert { Use[:procedure_id => @p1.id, :animal_id => @a2.id] } 
      assert { Use[:procedure_id => @p2.id, :animal_id => @a1.id] } 
      assert { Use[:procedure_id => @p2.id, :animal_id => @a2.id] } 
    end

    should "be able to list all the animals involved" do
      assert { @reservation.animal_names == [ @a1.name, @a2.name] }
    end


    should "be able to list all the procedures involved" do
      assert { @reservation.procedure_names == [ @p1.name, @p2.name] }
    end
  end


  should "delete both self and associated uses" do
    reservation = Reservation.random(:instructor => 'marge') do 
      use Animal.random(:name => 'animal')
      use Procedure.random(:name => 'procedure')
    end
    reservation.destroy
    deny { Reservation[:instructor => 'marge'] }
    assert { Reservation.all.size == 0 }
    assert { Use.all.size == 0 }
  end

  should "leave other reservations and uses alone" do
    deleteme = Reservation.random(:instructor => 'deleteme')
    saveme = Reservation.random(:instructor => 'saveme')
    deleteme.destroy
    deny { Reservation[:instructor => 'deleteme'] }
    assert { Reservation[:instructor => 'saveme'] }
  end
end
