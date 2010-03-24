$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

# TODO: Many of these tests test directly facts that are also tested
# by QueryMaker tests. If you change a test in this file, put into
# mock format and double-check that the facts are tested in the other
# class's tests.

class TupleCacheTests < FreshDatabaseTestCase
  def setup
    super

    @date = Date.new(2008,1,2)
    @reservation = Reservation.random
    @timeslice = Timeslice.new(@date, @date, TimeSet.new(MORNING))
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

  context "which animals are out of service as of a timeslice" do
    setup do 
      @timeslice = Timeslice.new(@date, @date+1, TimeSet.new(MORNING))

      Animal.random(:name => "animal out before", :date_removed_from_service => @date-1)
      Animal.random(:name => "animal out during", :date_removed_from_service => @date+1)
      Animal.random(:name => "animal out after", :date_removed_from_service => @date+2)
      @actual = @tuple_cache.animals_out_of_service(@timeslice)
    end

    should "be knowable" do
      assert { animal_named?(@actual, 'animal out before') } 
      assert { animal_named?(@actual, 'animal out during') } 
      deny { animal_named?(@actual, 'animal out after') } 
    end

    should "be cached" do
      DB[:animals].delete
      assert { @tuple_cache.animals_out_of_service(@timeslice).count > 0 }
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
end
