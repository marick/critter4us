require './test/testutil/requires'
require './strangled-src/model/requires'

class QueryMakerTests < FreshDatabaseTestCase
  def setup
    super
    @query = QueryMaker.new
    @reshaper = Reshaper.new
  end

  context "selecting columns" do 
    setup do
      Animal.random(:name => '1343', :nickname => 'toothy')
    end

    should "allow disambiguation" do
      result = @query.to_select_appropriate(:animal_name) do | q | 
        q.begin_with(:animals)
      end
      assert_equal([{:animal_name => '1343'}], result)
    end

    should "allow column names when not ambiguous" do
      result = @query.to_select_appropriate(:nickname) do | q |
        q.begin_with(:animals)
      end
      assert_equal([{:nickname => 'toothy'}], result)
    end
  end

  should "make qualified names" do 
    assert_equal(:table__column, @query.qualified(:table, :column))
  end

  context "joining exclusion tables" do 
    setup do 
      @animal = Animal.random(:name => '1343')
      @procedure = Procedure.random(:name => "floating")
      @reservation = Reservation.random
    end

    should "allow selection from either" do
      insert_tuple(:excluded_because_in_use, :animal_id => @animal.id,
                   :reservation_id => @reservation.id)
      result = @query.to_select_appropriate(:animal_name, :reservation_id) do | q | 
        q.begin_with(:excluded_because_in_use, :animals)
      end
      assert_equal([{:animal_name => '1343', :reservation_id => @reservation.id}],
                   result)
    end

    should "be independent of order" do
      insert_tuple(:excluded_because_in_use, :animal_id => @animal.id,
                   :reservation_id => @reservation.id)
      result = @query.to_select_appropriate(:animal_name, :reservation_id) do | q |
        q.begin_with(:animals, :excluded_because_in_use)
      end
      assert_equal([{:animal_name => '1343', :reservation_id => @reservation.id}],
                   result)
    end

    should "work with both exclusion tables and also procedures" do
      insert_tuple(:excluded_because_of_blackout_period, 
                   :animal_id => @animal.id, :procedure_id => @procedure.id,
                   :reservation_id => @reservation.id)
      result = @query.to_select_appropriate(:procedure_name, :reservation_id) do | q |
        q.begin_with(:excluded_because_of_blackout_period, :procedures)
      end
      assert_equal([{:procedure_name => 'floating', :reservation_id => @reservation.id}],
                   result)
    end

    should "allow both procedures and animals to be joined with exclusions" do
      insert_tuple(:excluded_because_of_blackout_period, 
                   :animal_id => @animal.id, :procedure_id => @procedure.id,
                   :reservation_id => @reservation.id)
      result = @query.to_select_appropriate(:procedure_name, :animal_name) do | q |
        q.begin_with(:procedures, :animals, :excluded_because_of_blackout_period)
      end
      assert_equal([{:procedure_name => 'floating', :animal_name => '1343'}],
                   result)
    end
  end

  context "flattening reservations" do
    should "contain animals and procedures" do 
      Reservation.random(:animal => Animal.random(:name => 'betsy'),
                         :procedure => Procedure.random(:name => 'route'),
                         :timeslice => Timeslice.new(Date.new(2009, 1, 1),
                                                     Date.new(2010, 2, 1),
                                                     TimeSet.new(MORNING)))
      result = @query.to_select_appropriate(:animal_name, :procedure_name, :first_date) do | q | 
        q.begin_with_flattened_reservations
      end
        
      assert_equal(1, result.size)
      assert_equal("betsy", result[0][:animal_name])
      assert_equal("route", result[0][:procedure_name])
      assert_equal(Date.new(2009,1,1), result[0][:first_date])
    end
  end

  should "add a clause that restricts to animals out of service (as of end date of timeslice)" do 
    out = Animal.random(:name => 'out').remove_from_service_as_of(Date.new(2009, 1, 20))
    still_in = Animal.random(:name => 'still in').remove_from_service_as_of(Date.new(2009, 1, 21))
    never_out = Animal.random(:name => 'never out')

    result = @query.to_select_appropriate(:animal_name) do | q |
      q.begin_with(:animals)
      q.restrict_to_tuples_with_animals_out_of_service(Timeslice.new(Date.new(2009,1,1),
                                                                     Date.new(2009,1,20)))
    end
    assert_equal(["out"],
                 @reshaper.tuples_to_presentable_array(result))
  end

  context "restricting animals ever used during desired timeslice (including time bits)" do

    should "work when desired moment is a single date" do
      timeslice = Timeslice.new(Date.new(2006, 6, 6),
                                Date.new(2006, 6, 6),
                                TimeSet.new(MORNING))
      insert_tuple(:excluded_because_in_use, :first_date => Date.new(2006, 6, 6),
                   :last_date => Date.new(2006,6,6),
                   :time_bits => "100",
                   :animal_id => Animal.random(:name => 'exact match').id)
      insert_tuple(:excluded_because_in_use, :first_date => Date.new(2006, 6, 6),
                   :last_date => Date.new(2006,6,6),
                   :time_bits => "101",
                   :animal_id => Animal.random(:name => 'overlapping time bits').id)
      insert_tuple(:excluded_because_in_use, :first_date => Date.new(2006, 6, 6),
                   :last_date => Date.new(2006,6,6),
                   :time_bits => "011",
                   :animal_id => Animal.random(:name => 'disjoint time bits').id)
      insert_tuple(:excluded_because_in_use, :first_date => Date.new(2006, 6, 7),
                   :last_date => Date.new(2006,6,7),
                   :time_bits => "100",
                   :animal_id => Animal.random(:name => 'different date').id)


      result = @query.to_select_appropriate(:animal_name) do | q |
        q.begin_with(:animals, :excluded_because_in_use)
        q.restrict_to_tuples_with_animals_in_use_during(timeslice)
      end
      assert_equal(["exact match", "overlapping time bits"], 
                   @reshaper.tuples_to_presentable_array(result))
    end

    should "work when timeslice moment is a range" do
      timeslice = Timeslice.new(Date.new(2006, 6, 6),
                                Date.new(2006, 6, 8),
                                TimeSet.new(MORNING))

      insert_tuple(:excluded_because_in_use, :first_date => Date.new(2006, 6, 6),
                   :last_date => Date.new(2006,6,8),
                   :time_bits => "100",
                   :animal_id => Animal.random(:name => 'exact match').id)
      insert_tuple(:excluded_because_in_use, :first_date => Date.new(2006, 6, 1),
                   :last_date => Date.new(2006,6,6),
                   :time_bits => "111",
                   :animal_id => Animal.random(:name => 'front touches').id)
      insert_tuple(:excluded_because_in_use, :first_date => Date.new(2006, 6, 1),
                   :last_date => Date.new(2006,6,5),
                   :time_bits => "111",
                   :animal_id => Animal.random(:name => 'entirely after').id)
      insert_tuple(:excluded_because_in_use, :first_date => Date.new(2006, 6, 8),
                   :last_date => Date.new(2006,6,16),
                   :time_bits => "111",
                   :animal_id => Animal.random(:name => 'back touches').id)
      insert_tuple(:excluded_because_in_use, :first_date => Date.new(2006, 6, 9),
                   :last_date => Date.new(2006,6,16),
                   :time_bits => "111",
                   :animal_id => Animal.random(:name => 'entirely before').id)
      insert_tuple(:excluded_because_in_use, :first_date => Date.new(2006, 6, 6),
                   :last_date => Date.new(2006,6,6),
                   :time_bits => "011",
                   :animal_id => Animal.random(:name => 'disjoint time bits').id)

      result = @query.to_select_appropriate(:animal_name) do | q | 
        q.begin_with(:animals, :excluded_because_in_use)
        q.restrict_to_tuples_with_animals_in_use_during(timeslice)
      end
      assert_equal(["back touches", "exact match", "front touches"],
                   @reshaper.tuples_to_presentable_array(result))
    end
  end


  context "exclusions due to blackout period" do 
    setup do
      @timeslice = Timeslice.new(Date.new(2000, 6, 6),
                                 Date.new(2000, 6, 9),
                                 TimeSet.new(MORNING))
      @animal = Animal.random(:name => 'betsy')
      @procedure = Procedure.random(:name => 'floating')
      @my_insert_tuple = lambda { | first_date, last_date, time_bits | 
        insert_tuple(:excluded_because_of_blackout_period,
                     :first_date => first_date,
                     :last_date => last_date,
                     :time_bits => time_bits,
                     :animal_id => @animal.id,
                     :procedure_id => @procedure.id)
      }
      @my_run = lambda { 
        @query.to_select_appropriate(:animal_name, :procedure_name) do | q | 
          q.begin_with(:animals, :procedures, :excluded_because_of_blackout_period)
          q.restrict_to_tuples_with_blackout_periods_overlapping(@timeslice)
        end
      }
    end

    

    should "include a tuple whose beginning touches the end" do
      @my_insert_tuple.call(Date.new(2000, 6, 1), Date.new(2000, 6, 6), "100")
      assert_equal([{:animal_name => "betsy", :procedure_name => "floating"}],
                   @my_run.call)
    end

    should "include a tuple whose end touches the beginning" do
      @my_insert_tuple.call(Date.new(2000, 6, 9), Date.new(2000, 6, 12), "100")
      assert_equal([{:animal_name => "betsy", :procedure_name => "floating"}],
                   @my_run.call)
    end

    should "remove a tuple that comes before" do
      @my_insert_tuple.call(Date.new(2000, 6, 1), Date.new(2000, 6, 5), "100")
      assert_equal([], @my_run.call)
    end

    should "remove a tuple that comes after" do
      @my_insert_tuple.call(Date.new(2000, 6, 10), Date.new(2000, 6, 10), "100")
      assert_equal([], @my_run.call)
    end

    should "not allow disjoint bits to exclude a tuple" do 
      @my_insert_tuple.call(Date.new(2000, 6, 9), Date.new(2000, 6, 12), "001")
      assert_equal([{:animal_name => "betsy", :procedure_name => "floating"}],
                   @my_run.call)
    end
  end

  should "return animals never taken out of service" do 
    Animal.random(:name => "never out")
    Animal.random(:name => "out", :date_removed_from_service => Date.new(2020, 12, 12))
    tuples = @query.to_select_appropriate(:animal_name) do | q | 
      q.begin_with(:animals)
      q.restrict_to_tuples_with_animals_not_removed_from_service
    end
    assert_equal([{:animal_name => "never out"}],
                 tuples)
  end

  context "knowing about animals reserved on or after a date" do
    setup do 
      @date = Date.new(2001, 1, 1)
    end

    should "not include animals in use only before that date" do 
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "a").id,
                   :first_date => @date - 3, :last_date => @date - 1)
      tuples = @query.to_select_appropriate(:animal_name) do | q | 
        q.begin_with(:animals, :excluded_because_in_use)
        q.restrict_to_tuples_in_use_on_or_after(@date)
      end
      assert_equal([], tuples)
    end

    should "include animals in use on that date" do 
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "a").id,
                   :first_date => @date - 3, :last_date => @date)
      tuples = @query.to_select_appropriate(:animal_name) do | q | 
        q.begin_with(:animals, :excluded_because_in_use)
        q.restrict_to_tuples_in_use_on_or_after(@date)
      end
      assert_equal([{:animal_name => "a"}], tuples)
    end

    should "include animals in use far after that date" do 
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "a").id,
                   :first_date => @date - 3, :last_date => @date)
      tuples = @query.to_select_appropriate(:animal_name) do | q | 
        q.begin_with(:animals, :excluded_because_in_use)
        q.restrict_to_tuples_in_use_on_or_after(@date)
      end
      assert_equal([{:animal_name => "a"}], tuples)
    end
  end

end
