require './test/testutil/fast-loading-requires'
require './src/db/full_reservation'
require './src/db/functional_timeslice'
require './strangled-src/model/requires'
require 'set'

class FullReservationTest < FreshDatabaseTestCase
  include FHUtil

  def setup
    @animal_1 = Animal.random(:name => "animal 1")
    @animal_2 = Animal.random(:name => "animal 2")
    @procedure_1 = Procedure.random(:name => "procedure 1")
    @procedure_2 = Procedure.random(:name => "procedure 2")
    
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
    use_to_be_excluded = use_to_be_retained = nil
    should "include animals that are in use during the timeslice" do
      @reservation.override(mocks(:timeslice_source, :timeslice))
      during {
        @reservation.without_excluded_animals
      }.behold! {
        @timeslice_source.should_receive(:from_reservation).
                          with(@reservation).
                          and_return(@timeslice)

        # The timeslice will mark one of the two animals as one to be excluded
        original_uses = @reservation.uses
        use_to_be_excluded = original_uses[0] + {should_be_excluded: true}
        use_to_be_retained = original_uses[1] + {should_be_excluded: false}
        @timeslice.should_receive(:mark_excluded_uses).
                   with(original_uses).
                   and_return([use_to_be_excluded, use_to_be_retained])
      }
      assert { @result.uses.size == 1 }
      assert { @result.uses[0].animal_name == use_to_be_retained.animal_name }
      assert { @result.groups == @reservation.groups } # No change, but one is empty
      assert { @result.animals_with_scheduling_conflicts == [use_to_be_excluded.animal_name] }
    end
  end

  context "`as_saved`" do
    should "put the reservation on disk and return the new copy" do
      @reservation.uses
      new_reservation = @reservation.as_saved
      new_reservation.uses

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
    end
  end
end
