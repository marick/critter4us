require './test/testutil/requires'
require './model/requires'

# TODO: Many of these tests test directly facts that are also tested
# by QueryMaker tests. For simplicity, the tests should not check edge
# cases. If you modify tests that do, move them into the QueryMaker
# tests.


class TupleCacheTests < FreshDatabaseTestCase
  def setup
    super

    @date = Date.new(2008,1,2)
    @timeset = TimeSet.new(MORNING)
    @reservation = Reservation.random
    @timeslice = Timeslice.new(@date, @date, @timeset)
    @tuple_cache = TupleCache.new
  end

  def matching_key_value?(array, key, value)
    array.find { | tuple | tuple[key] == value }
  end

  def animal_named?(array, name)
    matching_key_value?(array, :animal_name, name)
  end
  alias_method :animal_named, :animal_named?

  def procedure_named?(array, name)
    matching_key_value?(array, :procedure_name, name)
  end

  context "finding which animals are in use" do
    setup do
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "betsy").id,
                   :first_date => @timeslice.first_date, :last_date => @timeslice.last_date,
                   :time_bits => @timeslice.time_bits,
                   :reservation_id => @reservation.id)
      @actual = @tuple_cache.animals_in_use(@timeslice)
    end

    should "be discoverable" do
      assert_equal('betsy', @actual[0][:animal_name])
      assert_equal(@reservation.id, @actual[0][:reservation_id])
    end

    should "be cached" do
      DB[:excluded_because_in_use].delete
      assert { @tuple_cache.animals_in_use(@timeslice).count > 0 }
    end

  end


  context "which animals have been reserved during or after a timeslice" do 
    setup do 
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use before").id,
                   :first_date => @date-2, :last_date => @date-1)
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use during").id,
                   :first_date => @date-2, :last_date => @date,
                   :time_bits => "001") # not intersecting
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use after").id,
                   :first_date => @date+100, :last_date => @date+101)
      @actual = @tuple_cache.animals_still_working_hard_on(@date)
    end

    should "be discoverable" do 
      deny { animal_named?(@actual, 'in use before') } 
      assert { animal_named?(@actual, 'in use during') }
      assert { animal_named?(@actual, 'in use after') }
    end

    should "be cached" do
      DB[:excluded_because_in_use].delete
      assert { @tuple_cache.animals_still_working_hard_on(@date).count > 0 }
    end
  end

  context "which animals are ever out of service" do
    setup do 
      Animal.random(:name => "animal out", :date_removed_from_service => @date - 100)
      Animal.random(:name => "... even if taken out at future date",
                    :date_removed_from_service => @date + 100)
      Animal.random(:name => "animal in")
      @actual = @tuple_cache.animals_ever_out_of_service
    end

    should "be knowable" do
      assert { animal_named?(@actual, 'animal out') } 
      assert { animal_named?(@actual, '... even if taken out at future date') }
      deny { animal_named?(@actual, 'animal in ') }
    end

  end

  context "which animals are in or out of service as of a timeslice" do
    setup do 
      @timeslice = Timeslice.new(@date, @date+1, TimeSet.new(MORNING))

      Animal.random(:name => "animal out before", :date_removed_from_service => @date-1)
      Animal.random(:name => "animal out during - begin", :date_removed_from_service => @date)
      Animal.random(:name => "animal out during - end", :date_removed_from_service => @date+1)
      Animal.random(:name => "animal out after", :date_removed_from_service => @date+2)
      Animal.random(:name => "never removed")
      @actual_in = @tuple_cache.animals_in_service(@timeslice)
      @actual_out = @tuple_cache.animals_out_of_service(@timeslice)
    end

    should "be knowable" do
      assert { animal_named?(@actual_out, 'animal out before') } 
      assert { animal_named?(@actual_out, 'animal out during - begin') } 
      assert { animal_named?(@actual_out, 'animal out during - end') } 
      deny { animal_named?(@actual_out, 'animal out after') } 
      deny { animal_named?(@actual_out, 'never removed') } 

      deny { animal_named?(@actual_in, 'animal out before') } 
      assert { animal_named?(@actual_in, 'animal out during - begin') } 
      assert { animal_named?(@actual_in, 'animal out during - end') } 
      assert { animal_named?(@actual_in, 'animal out after') } 
      assert { animal_named?(@actual_in, 'never removed') } 
    end

    should "be cached" do
      DB[:animals].delete
      assert { @tuple_cache.animals_out_of_service(@timeslice).count > 0 }
      assert { @tuple_cache.animals_in_service(@timeslice).count > 0 }
    end
  end

  context "all animals" do
    setup do 
      Animal.random(:name => "including animals out of service",
                    :date_removed_from_service => @date)
      Animal.random(:name => 'normal')
      @actual = @tuple_cache.all_animals
    end

    should "be knowable" do
      assert { animal_named?(@actual, 'including animals out of service') } 
      assert { animal_named?(@actual, 'normal') }
    end

    should "be cached" do
      DB[:animals].delete
      assert { @tuple_cache.all_animals.count > 0 }
    end
  end

  context "all procedures" do
    setup do 
      Procedure.random(:name => 'normal')
      @actual = @tuple_cache.all_procedures
    end

    should "be knowable" do
      assert { procedure_named?(@actual, 'normal') }
    end

    should "be cached" do
      DB[:procedures].delete
      assert { @tuple_cache.all_procedures.count > 0 }
    end
  end

  context "conflicting animals and procedures" do
    setup do 
      @procedure = 
      DB[:excluded_because_of_animal].insert(
                   :animal_id => Animal.random(:name => "a").id,
                   :procedure_id => Procedure.random(:name => "p - no a").id)
      DB[:excluded_because_of_animal].insert(
                   :animal_id => Animal.random(:name => "b").id,
                   :procedure_id => Procedure.random(:name => "p - no b").id)
      @actual = @tuple_cache.animals_with_procedure_conflicts
    end

    should "be findable" do 
      assert { @actual.length == 2 } 
      assert { animal_named(@actual, 'a')[:procedure_name] == "p - no a" }
      assert { animal_named(@actual, 'b')[:procedure_name] == "p - no b" }
    end

    should "be cached" do
      DB[:excluded_because_of_animal].delete
      assert { @tuple_cache.animals_with_procedure_conflicts.count > 0 }
    end
  end

  context "which animals are in a blackout period" do 
    setup do 
      insert_tuple(:excluded_because_of_blackout_period,
                   :animal_id => Animal.random(:name => "unusable").id,
                   :first_date => @date-12, :last_date => @date+13, :time_bits => "100",
                   :procedure_id => Procedure.random(:name => "procedure").id,
                   :reservation_id => @reservation.id)
      @actual = @tuple_cache.animals_blacked_out(@timeslice)
    end

    should "be knowable" do 
      assert_equal([{:procedure_name => "procedure", :animal_name => "unusable",
                      :reservation_id => @reservation.id }],
                   @actual)
    end

    should "be cached" do 
      DB[:excluded_because_of_blackout_period].delete
      assert { @tuple_cache.animals_blacked_out(@timeslice).count > 0 }
    end
  end

  context "returning animals and procedures used during a date" do 
    setup do 
      @timeslice = Timeslice.new(@date, @date+1, TimeSet.new(MORNING))
      Reservation.random(:timeslice => @timeslice, 
                         :animal => Animal.random,
                         :procedure => Procedure.random)
      Animal.random(:name => 'unused animal')
      @actual = @tuple_cache.animal_usage(@timeslice)
    end

    should "be knowable" do 
      assert_equal(1, @actual.size)
      assert(@actual[0][:animal_name])
      assert(@actual[0][:procedure_name])
    end

    should "be cached" do 
      DB[:reservations].delete
      assert(1, @tuple_cache.animal_usage(@timeslice).size)
    end
  end
end
