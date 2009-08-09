require 'test/testutil/requires'
require 'test/testutil/config'
require 'test/testutil/dbhelpers'
require 'admin/tables'
require 'model'

class ModelTests < Test::Unit::TestCase
  def setup
    empty_tables
  end

  context "animals" do
    should "collectively be able to return their names" do
      create(Animal, 'c', 'a', 'b')
      assert { Animal.names.sort == ['a', 'b', 'c'] }
    end
  end


  context "procedures" do 
    should "collectively be able to return their names" do 
      create(Procedure, 'c', 'a', 'b')
      assert { Procedure.names.sort == ['a', 'b', 'c'] }
    end
  end

  context "reservations" do
    should "can create a single 'nested' uses" do
      create(Procedure, 'procedure')
      create(Animal, 'animal')
      date = Date.new(2009, 7, 23)
      reservation = Reservation.create_with_uses(date,
                                                 ['procedure'],
                                                 ['animal'])
      assert { reservation.date == date }
      assert { reservation.uses.size == 1 }
      use = reservation.uses[0]
      assert { use.animal.name == 'animal' }
      assert { use.procedure.name == 'procedure' }
      assert { use.reservation == reservation }
    end

    context "multiple animals and procedures" do 

      setup do
        @p1, @p2 = create(Procedure, 'p1', 'p2')
        @a1, @a2 = create(Animal, 'a1', 'a2')
        @date = Date.new(2009, 7, 23)
        @reservation = Reservation.create_with_uses(@date,
                                                   ['p1', 'p2'],
                                                   ['a1', 'a2'])
      end

      should "can create the cross-product of procedures and animals" do
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
  end

end

