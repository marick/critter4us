$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ReservationMakerTests < FreshDatabaseTestCase

  context "setting of time fields directly" do 
    setup do 
      @constant = {
        :instructor => 'marge',
        :course => 'vm333',
        :first_date => Date.new(2001, 1, 1),
        :last_date => Date.new(2001, 1, 1),
        :groups => [
                    {:procedures => ['procedure'],
                      :animals => ['animal']}
                   ]
      }
    end

    should "allow all to be set" do
      test_data = @constant.merge(:morning => true, :afternoon => true, :evening => true)
      reservation = ReservationMaker.build_from(test_data)
      assert { reservation.times == TimeSet.new(MORNING, AFTERNOON, EVENING) }
    end

    should "allow all to be un-set" do
      test_data = @constant.merge(:morning => false, :afternoon => false, :evening => false)
      reservation = ReservationMaker.build_from(test_data)
      assert { reservation.times == TimeSet.new }
    end

    should "treat missing as false" do
      reservation = ReservationMaker.build_from(@constant)
      assert { reservation.times == TimeSet.new }
    end
  end

  context "setting of time fields with a set" do
    setup do 
      @constant = {
        :instructor => 'marge',
        :course => 'vm333',
        :first_date => Date.new(2001, 1, 1),
        :last_date => Date.new(2001, 1, 1),
        :groups => []
      }
    end

    should "allow all to be set" do
      test_data = @constant.merge(:times => TimeSet.new(MORNING, AFTERNOON, EVENING))
      reservation = ReservationMaker.build_from(test_data)
      assert { reservation.times == TimeSet.new(MORNING, AFTERNOON, EVENING) }
    end

    should "allow all to be un-set" do
      test_data = @constant.merge(:times => TimeSet.new)
      reservation = ReservationMaker.build_from(test_data)
      assert { reservation.times == TimeSet.new }
    end
  end

  context "a single group" do 
    should "create a single use of an animal and procedure" do
      Procedure.random(:name => 'procedure')
      Animal.random(:name => 'animal')
      
      test_data = {
        :instructor => 'marge',
        :course => 'vm333',
        :first_date => Date.new(2001, 1, 1),
        :last_date => Date.new(2001, 1, 1),
        :times => TimeSet.new(MORNING),
        :groups => [
                    {:procedures => ['procedure'],
                      :animals => ['animal']}
                   ]
      }
      actual_reservation = ReservationMaker.build_from(test_data)
      assert { actual_reservation.groups.size == 1 }

      actual_group = actual_reservation.groups[0]
      assert { actual_group.reservation == actual_reservation } 
      assert { actual_group.uses.size == 1 }

      actual_use = actual_group.uses[0]
      assert { actual_use.group == actual_group }

      assert { actual_use.animal.name == 'animal' }
      assert { actual_use.procedure.name == 'procedure' }
    end
  end

  context "multiple animals and procedures in one group" do 

    setup do
      @p1 = Procedure.random(:name => 'p1')
      @p2 = Procedure.random(:name => 'p2')
      @a1 = Animal.random(:name => 'a1')
      @a2 = Animal.random(:name => 'a2')
      test_data = {
        :instructor => 'marge',
        :course => 'vm333',
        :first_date => Date.new(2001, 2, 4),
        :first_date => Date.new(2001, 2, 4),
        :times => TimeSet.new(AFTERNOON),
        :groups => [ {:procedures => ['p1', 'p2'],
                       :animals => ['a1', 'a2']} ]
      }
      @reservation = ReservationMaker.build_from(test_data)
    end

    should "create the cross-product of procedures and animals" do
      assert { Use.all.size == 4 }
      assert { Use[:procedure_id => @p1.id, :animal_id => @a1.id] } 
      assert { Use[:procedure_id => @p1.id, :animal_id => @a2.id] } 
      assert { Use[:procedure_id => @p2.id, :animal_id => @a1.id] } 
      assert { Use[:procedure_id => @p2.id, :animal_id => @a2.id] } 
    end

    should "include the cross-product in a single group" do
      assert { @reservation.groups.size == 1 } 
      Use.all.each do | use |
        assert { use.group.id == Group.first.id }
      end
    end

    should "be able to list all the animals involved" do
      assert { @reservation.animal_names == [ @a1.name, @a2.name] }
    end


    should "be able to list all the procedures involved" do
      assert { @reservation.procedure_names == [ @p1.name, @p2.name] }
    end
  end


  context "multiple groups" do 

    setup do
      @p1 = Procedure.random(:name => 'p1')
      @p2 = Procedure.random(:name => 'p2')
      @p3 = Procedure.random(:name => 'p3')
      @a1 = Animal.random(:name => 'a1')
      @a2 = Animal.random(:name => 'a2')
      test_data = {
        :instructor => 'marge',
        :course => 'vm333',
        :first_date => Date.new(2001, 2, 4),
        :last_date => Date.new(2001, 2, 4),
        :times => TimeSet.new(EVENING),
        :groups => [ {:procedures => ['p1', 'p2'],
                       :animals => ['a1']},
                     {:procedures => ['p3'],
                       :animals => ['a2']}]
      }
      @reservation = ReservationMaker.build_from(test_data)

      @p1_a1 = Use[:procedure_id => @p1.id, :animal_id => @a1.id]
      @p2_a1 = Use[:procedure_id => @p2.id, :animal_id => @a1.id]
      @p3_a2 = Use[:procedure_id => @p3.id, :animal_id => @a2.id]
    end

    should "create the cross-product only within a group" do
      assert { Use.all.size == 3 }
      assert { @p1_a1 } 
      assert { @p2_a1 } 
      assert { @p3_a2 } 
    end

    should "use two groups" do
      assert { @reservation.groups.size == 2 } 
      assert { @p1_a1.group == @p2_a1.group  } 
      assert { @p1_a1.group != @p3_a2.group } 
    end

    should "be able to list all the animals involved" do
      assert { @reservation.animal_names == [ @a1.name, @a2.name] }
    end


    should "be able to list all the procedures involved" do
      assert { @reservation.procedure_names == [ @p1.name, @p2.name, @p3.name] }
    end


    should "be able to return the procedure objects involved" do
      assert { @reservation.procedures == [ @p1, @p2, @p3] }
    end
  end

end

