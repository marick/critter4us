$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ReservationModelTests < FreshDatabaseTestCase

  context "different times" do 
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
      reservation = Reservation.create_with_groups(test_data)
      assert { reservation.morning } 
      assert { reservation.afternoon } 
      assert { reservation.evening } 
    end

    should "allow all to be un-set" do
      test_data = @constant.merge(:morning => false, :afternoon => false, :evening => false)
      reservation = Reservation.create_with_groups(test_data)
      deny { reservation.morning } 
      deny { reservation.afternoon } 
      deny { reservation.evening } 
    end

    should "treat missing as false" do
      reservation = Reservation.create_with_groups(@constant)
      deny { reservation.morning } 
      deny { reservation.afternoon } 
      deny { reservation.evening } 
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
        :morning => true,
        :groups => [
                    {:procedures => ['procedure'],
                      :animals => ['animal']}
                   ]
      }
      actual_reservation = Reservation.create_with_groups(test_data)
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
        :afternoon => true,
        :groups => [ {:procedures => ['p1', 'p2'],
                       :animals => ['a1', 'a2']} ]
      }
      @reservation = Reservation.create_with_groups(test_data)
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
        :evening => true,
        :groups => [ {:procedures => ['p1', 'p2'],
                       :animals => ['a1']},
                     {:procedures => ['p3'],
                       :animals => ['a2']}]
      }
      @reservation = Reservation.create_with_groups(test_data)

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

  context "replacing data" do 
    setup do 
      @reservation = Reservation.random(:instructor => 'marge',
                                      :course => 'vm333',
                                      :first_date => Date.new(2001, 1, 1),
                                      :last_date => Date.new(2001, 2, 2),
                                      :morning => true) do 
        use Animal.random(:name => 'animal')
        use Procedure.random(:name => 'procedure')
      end
      @betsy = Animal.random(:name => 'betsy')
      @jake = Animal.random(:name => 'jake')
      @floating = Procedure.random(:name => 'floating')
      @venipuncture = Procedure.random(:name => 'venipuncture')

      @old_group_ids = @reservation.groups.collect { | g | g.id }
      @old_use_ids = @reservation.uses.collect { | u | u.id }

      @new_data = {
        :instructor => 'not marge',
        :course => 'not vm333',
        :first_date => Date.new(2012, 11, 11),
        :last_date => Date.new(2012, 12, 12),
        :evening => true,
        :groups => [ {:procedures => ['venipuncture'],
                       :animals => ['betsy']},
                     {:procedures => ['floating'],
                       :animals => ['jake', 'betsy']}]
      }

      @retval = @reservation.with_updated_groups(@new_data)
    end

    should "return self" do 
      assert @retval.object_id == @reservation.object_id
    end


    should "delete old groups" do
      @old_group_ids.each do | id |
        deny { Group[id] }
      end
      @old_use_ids.each do | id | 
        deny { Use[id] }
      end
    end

    should "add new groups" do
      new_reservation = Reservation[@reservation.pk]

      assert { new_reservation.groups.length == 2 }
      assert { new_reservation.uses.length == 3 }
      assert { Use[:procedure_id => @venipuncture.id, :animal_id => @betsy.id] }
      assert { Use[:procedure_id => @floating.id, :animal_id => @jake.id] }
      assert { Use[:procedure_id => @floating.id, :animal_id => @betsy.id] }
    end

    should "replace unstructured data" do
      new_reservation = Reservation[@reservation.pk]
      assert { new_reservation.instructor == @new_data[:instructor] }
      assert { new_reservation.course == @new_data[:course] }
      assert { new_reservation.first_date == @new_data[:first_date]}
      assert { new_reservation.last_date == @new_data[:last_date]}
      assert { new_reservation.evening }
      deny { new_reservation.afternoon }
      deny { new_reservation.morning }
    end

  end

  should "delete both self and associated uses and groups" do
    reservation = Reservation.random(:instructor => 'marge') do 
      use Animal.random(:name => 'animal')
      use Procedure.random(:name => 'procedure')
    end

    assert { Reservation[:instructor => 'marge'] }
    assert { Reservation.all.size == 1 }
    assert { Group.all.size == 1 }
    assert { Use.all.size == 1 }

    reservation.destroy

    deny { Reservation[:instructor => 'marge'] }
    assert { Reservation.all.size == 0 }
    assert { Group.all.size == 0 }
    assert { Use.all.size == 0 }
  end

  should "leave other reservations and uses alone" do
    deleteme = Reservation.random(:instructor => 'deleteme')
    saveme = Reservation.random(:instructor => 'saveme')
    deleteme.destroy
    deny { Reservation[:instructor => 'deleteme'] }
    assert { Reservation[:instructor => 'saveme'] }
  end

  should "produce a sorted, uniquified list of kinds in use that are relevant to procedure descriptions" do
    Procedure.random(:name => 'procedure')
    flicka = Animal.random(:name => 'flicka', :kind => 'mare', :procedure_description_kind => 'equine')
    betsy = Animal.random(:name => 'betsy', :kind => 'cow', :procedure_description_kind => 'bovine')
    jake = Animal.random(:name => 'jake', :kind => 'gelding', :procedure_description_kind => 'equine')

    test_data = {
      :instructor => 'marge',
      :course => 'vm333',
      :first_date => Date.new(2001, 2, 4),
      :first_date => Date.new(2001, 2, 5),
      :morning => true,
      :groups => [
                  {:procedures => ['procedure'],
                    :animals => ['flicka', 'jake']},
                  {:procedures => ['procedure'],
                    :animals => ['betsy', 'flicka']}
                ]
    }
    reservation = Reservation.create_with_groups(test_data)

    assert { ['bovine', 'equine'] == reservation.procedure_description_kinds }
  end

    
  should "know about own uses" do 
    animal = Animal.random
    procedure = Procedure.random
    reservation = Reservation.random(:animal => animal, :procedure => procedure)

    assert { reservation.uses == reservation.groups[0].uses }
  end

  should "allow reservation to return a timeslice" do
    first_date = Date.new(2002, 2, 4)
    last_date = Date.new(2002, 2, 5)
    created = Reservation.random(:first_date => first_date,
                                 :last_date => last_date,
                                 :morning => true,
                                 :afternoon => true,
                                 :evening => false)
    reservation_to_ignore = Reservation.acts_as_empty
    derived_timeslice = created.timeslice(reservation_to_ignore)
    assert_equal(first_date, derived_timeslice.first_date)
    assert_equal(last_date, derived_timeslice.last_date)
    assert_equal(Set.new([MORNING, AFTERNOON]), derived_timeslice.times)
    assert_equal(reservation_to_ignore, derived_timeslice.ignored_reservation)
  end
end
