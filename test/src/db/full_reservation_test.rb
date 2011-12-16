require './test/testutil/fast-loading-requires'
require './src/db/full_reservation'
require './src/db/functional_timeslice'
require './strangled-src/model/requires'
require 'set'

class FullReservationTest < FreshDatabaseTestCase

  def setup
    Animal.random(:name => "animal 1")
    Animal.random(:name => "animal 2")
    Procedure.random(:name => "procedure 1")
    Procedure.random(:name => "procedure 2")
    data = {
      :timeslice => Timeslice.new(Date.new(2009, 7, 23),
                                  Date.new(2009, 8, 24),
                                  TimeSet.new(MORNING)),
      :course => 'vm333',
      :instructor => 'morin',
      :groups => [ {:procedures => ['procedure 1'], :animals => ['animal 1'] }, 
                   {:procedures => ['procedure 2'], :animals => ['animal 2'] } ]
    }
    @old_format = ReservationMaker.build_from(data)
    @reservation = FullReservation.from_id(@old_format.id)
  end

  should "be read from database" do
    assert { @reservation.starting_id == @old_format.id }
    assert { @reservation.data.instructor == 'morin' }
    assert { @reservation.data.course == 'vm333' }
    assert { @reservation.data.first_date == Date.new(2009, 7, 23) }
    assert { @reservation.data.last_date == Date.new(2009, 8, 24) }
    assert { @reservation.data.time_bits == "100" }

    assert { Set.new(@reservation.uses.map(&:animal_name)) ==
      Set.new(['animal 1', 'animal 2']) 
    }
    assert { Set.new(@reservation.uses.map(&:procedure_name)) ==
      Set.new(['procedure 1', 'procedure 2'])
    }
    assert { Set.new(@reservation.uses.map(&:group_id)) ==
      Set.new(@reservation.groups.map(&:id))
    }
  end

  context "data access" do
    should "return animal names" do
      assert { Set.new(@reservation.animal_names) == 
               Set.new(["animal 1", "animal 2"]) }
    end
    should "return procedure names" do
      assert { Set.new(@reservation.procedure_names) == 
               Set.new(["procedure 1", "procedure 2"]) }
    end
  end

  context "changing the time" do 
    setup do
      timeslice = F(:first_date => @reservation.data.first_date + 1,
                    :last_date => @reservation.data.last_date + 2,
                    :time_bits => "111")
      @new_reservation = @reservation.with_changed_timeslice(timeslice)
    end

    should "change the three relevant fields" do 
      assert { @new_reservation.data.first_date == Date.new(2009, 7, 24) }
      assert { @new_reservation.data.last_date == Date.new(2009, 8, 26) }
      assert { @new_reservation.data.time_bits == "111" }
    end

    should "not affect the original reservation"  do
      assert { @reservation.data.first_date == Date.new(2009, 7, 23) }
      assert { @reservation.data.last_date == Date.new(2009, 8, 24) }
      assert { @reservation.data.time_bits == "100" }
    end

    should "not change other fields" do 
      assert { @new_reservation.data.instructor == @reservation.data.instructor }
      assert { @new_reservation.uses == @reservation.uses } 
    end

    should "clear out the id field to prevent accidental overwriting" do
      assert { ! @new_reservation.data.has_key?(:id) }
      # but still has record of original
      assert { @new_reservation.starting_id == @reservation.starting_id }
    end
  end
  
  context "pruning uses when there is a scheduling conflict with an animal" do
    setup do 
      @reservation.override(mocks(:timeslice_source, :timeslice))
      @use_that_conflicts, @use_without_conflict = @reservation.uses
    end

    should "prune and identify animals that are in use during the timeslice" do
      animal_ids_in_use = [@use_that_conflicts.animal_id, "some irrelevant one"]
      during {
        @reservation.without_animals_in_use
      }.behold! {
        @timeslice_source.should_receive(:from_reservation).
                          with(@reservation).
                          and_return(@timeslice)
        @timeslice.should_receive(:animal_ids_in_use).
                   and_return(animal_ids_in_use)
      }
      assert { @result.uses.size == 1 }
      deny { @result.uses.any? { | u | u.animal_id == @use_that_conflicts.animal_id } }
      assert { @result.uses.any? { | u | u.animal_id == @use_without_conflict.animal_id } }
      assert { @result.animals_already_in_use == [ @use_that_conflicts.animal_name ] }
    end

    should "prune and identify uses that are blacked out during the timeslice" do
      blacked_out = [@use_that_conflicts.only(:animal_id, :procedure_id),
                     F(animal_id: "not relevant to", procedure_id: "this reservation")]
      corresponding_pairs = [@use_that_conflicts.only(:animal_name, :procedure_name)]
      during {
        @reservation.without_blacked_out_use_pairs
      }.behold! {
        @timeslice_source.should_receive(:from_reservation).
                          with(@reservation).
                          and_return(@timeslice)
        @timeslice.should_receive(:use_pairs_blacked_out).
                   and_return(blacked_out)
      }
      assert { @result.uses == [@use_without_conflict] }
      assert { @result.blacked_out_use_pairs == corresponding_pairs }
    end
  end

  context "`as_saved`" do

    setup do 
      @reservation_data_checks = lambda { | new_reservation | 
        assert { @reservation.data != new_reservation.data } # ... because of id
        assert { @reservation.data - :id == new_reservation.data - :id }

        assert { 
          new_reservation.groups.all? { | group | group.reservation_id == new_reservation.data.id }
        }

        assert { new_reservation.uses.size == 2 }
        use_1 = new_reservation.uses.find { | use | use.animal_name == 'animal 1' }
        assert { use_1.procedure_name == 'procedure 1' } 
        assert { new_reservation.groups.find { | group | group.id == use_1.group_id} } 

        use_2 = new_reservation.uses.find { | use | use.animal_name == 'animal 2' }
        assert { use_2.procedure_name == 'procedure 2' } 
        assert { new_reservation.groups.find { | group | group.id == use_2.group_id} } 

        assert { use_2.group_id != use_1.group_id }
      }
    end

    should "return data with new ids" do
      @reservation_data_checks.(@reservation.as_saved)
    end

    should "put the reservation on disk" do
      @reservation_data_checks.(FullReservation.from_id(@reservation.as_saved.data.id))
      @reservation_data_checks.(FullReservation.from_id(@reservation.as_saved.starting_id))
    end

    should "retain non-persistent data that was attached to the reservation" do
      new_reservation = @reservation.merge(retain_me: "Please").as_saved
      assert { new_reservation.retain_me == "Please" }
    end
  end
end

