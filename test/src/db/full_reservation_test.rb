require './test/testutil/fast-loading-requires'
require './src/db/full_reservation'
require './src/db/functional_timeslice'
require './strangled-src/model/requires'

class FullReservationTest < FreshDatabaseTestCase
  include FHUtil

  def setup
    @animal_1 = Animal.random(:name => "animal 1")
    @animal_2 = Animal.random(:name => "animal 2")
    @procedure_1 = Procedure.random(:name => "procedure 1")
    @procedure_2 = Procedure.random(:name => "procedure 2")
    @old_format = Reservation.random(:animal => @animal_1,
                                     :procedure => @procedure_1,
                                     :timeslice => Timeslice.new(Date.new(2009, 7, 23),
                                                                 Date.new(2009, 8, 24),
                                                                 TimeSet.new(MORNING)),
                                     :course => 'vm333',
                                     :instructor => 'morin')
    @reservation = FullReservation.from_id(@old_format.id)
  end

  should "be read from database" do
    assert { @reservation.starting_id == @old_format.id }
    assert { @reservation.data.instructor == 'morin' }
    assert { @reservation.data.course == 'vm333' }
    assert { @reservation.data.first_date == Date.new(2009, 7, 23) }
    assert { @reservation.data.last_date == Date.new(2009, 8, 24) }
    assert { @reservation.data.time_bits == "100" }

    only_use = @reservation.uses.first
    assert { only_use.animal_name == 'animal 1' }
    assert { only_use.procedure_name == 'procedure 1' }
    assert { only_use.group_id == @reservation.groups.first.id }
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
    should "include animals that are in use during the timeslice" do
      @reservation.override(mocks(:timeslice_source, :timeslice))
      during {
        @reservation.without_excluded_animals
      }.behold! {
        @timeslice_source.should_receive(:from_reservation).
                          with(@reservation).
                          and_return(@timeslice)
        @timeslice.should_receive(:animals_excluded_during).
                   and_return([@animal_1.id])
      }
      assert { @result.uses == [] }
      assert { @result.groups != [] }
      assert { @result.animals_with_scheduling_conflicts == [@animal_1.name] }
    end
  end

  context "`as_saved`" do
    should "put the reservation on disk and return the new copy" do
      new_one = @reservation.as_saved

      assert { @reservation.data != new_one.data } # ... because of id
      assert { @reservation.data - :id == new_one.data - :id }

      assert { @reservation.groups.first != new_one.groups.first }
      assert { @reservation.groups.first - :id != new_one.groups.first - :id }

      assert { @reservation.uses.first != new_one.uses.first }
      assert { @reservation.uses.first - :id != new_one.uses.first - :id }
    end

    should "work even with multiple groups" do
      two_groups = Fall([{id: 5, reservation_id: @reservation.data.id},
                         {id: 33, reservation_id: @reservation.data.id}])
      two_uses = Fall([{group_id: 5, animal_id: @animal_1.id, procedure_id: @procedure_1.id},
                       {group_id: 33, animal_id: @animal_2.id, procedure_id: @procedure_2.id}])

      new_one = @reservation.merge(:groups => two_groups, :uses => two_uses).as_saved


      groups = new_one.groups.sort { | a, b | a.id <=> b.id }
      uses = new_one.uses.sort { | a, b | a.group_id <=> b.group_id } 

      assert { groups[0].id == uses[0].group_id }
      assert { groups[1].id == uses[1].group_id }
    end
  end
  
  
end
