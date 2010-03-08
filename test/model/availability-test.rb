$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class AvailabilityTests < FreshDatabaseTestCase
  def setup
    super

    @date = Date.new(2008,1,2)
    @reservation = Reservation.random
    @timeslice = Timeslice.new(@date, @date, TimeSet.new(MORNING))
    @availability = Availability.new(@timeslice)
    @availability_with_reservation = Availability.new(@timeslice, @reservation.id)
    @reshaper = Reshaper.new
  end

  should "return all animal names" do
    Animal.random(:name => "included")
    Animal.random(:name => "also included", :date_removed_from_service => @date - 100)
    assert_equal(["also included", "included"],
                 @availability.all_animals)
  end

  context "animals prohibited/reservable at this time" do
    setup do 
      Animal.random(:name => "out of service", :date_removed_from_service => @date)
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use at the moment").id,
                   :first_date => @date, :last_date => @date, :time_bits => "100",
                   :reservation_id => @reservation.id)
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "bits do not overlap").id,
                   :first_date => @date, :last_date => @date, :time_bits => "011",
                   :reservation_id => @reservation.id)
      Animal.random(:name => "some other animal")
    end

    should "interpret query results correctly" do
      assert_equal(["in use at the moment", "out of service"],
                   @availability.animals_prohibited_for_this_timeslice)
      assert_equal(["bits do not overlap", "some other animal"],
                   @availability.animals_that_can_be_reserved)
    end

    should "take reservation into account" do 
      assert_equal(["out of service"],
                   @availability_with_reservation.animals_prohibited_for_this_timeslice)
      assert_equal(["bits do not overlap", "in use at the moment", "some other animal"],
                   @availability_with_reservation.animals_that_can_be_reserved)
    end
  end

  should "retrieve procedures" do 
    Procedure.random(:name => "procedure")
    assert_equal(["procedure"],
                 @availability.procedures_that_can_be_assigned)
  end

  context "procedure/animal tuples not reservable during this timeslice" do 
    setup do 
      insert_tuple(:excluded_because_of_blackout_period,
                   :animal_id => Animal.random(:name => "unusable").id,
                   :first_date => @date-12, :last_date => @date+13, :time_bits => "100",
                   :procedure_id => Procedure.random(:name => "procedure").id,
                   :reservation_id => @reservation.id)
    end

    should "produce blacked-out tuples" do 
      assert_equal([{:procedure_name => "procedure", :animal_name => "unusable",
                      :reservation_id => @reservation.id }],
                   @availability.tuples__animals_blacked_out)
    end

    should "not be included if they match the reservation given to availability" do
      assert_equal([], 
                   @availability_with_reservation.tuples__animals_blacked_out)
    end
  end

  context "exclusions due to reservations" do 
    setup do 
      Animal.random(:name => "unused animal")
      Procedure.random(:name => "unused procedure")
    end

    should "produce a map for all procedures" do 
      assert_equal({ "unused procedure" => [] },
                   @availability.exclusions_due_to_reservations)
    end

    should "create animal-in-use exclusions for each procedure" do 
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use").id,
                   :first_date => @date, :last_date => @date,
                   :time_bits => "100")
      assert_equal( {'unused procedure' => ["in use"]},
                   @availability.exclusions_due_to_reservations)
    end

    should "include procedure-specific blackout exclusions" do 
      insert_tuple(:excluded_because_of_blackout_period,
                   :animal_id => Animal.random(:name => "blacked out").id,
                   :procedure_id => Procedure.random(:name => "used").id,
                   :first_date => @date, :last_date => @date,
                   :time_bits => "100")
      assert_equal( {'unused procedure' => [],
                     'used' => ['blacked out']},
                   @availability.exclusions_due_to_reservations)
    end

    should "omit animals belonging to given reservation" do 
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use").id,
                   :first_date => @date, :last_date => @date,
                   :time_bits => "100",
                   :reservation_id => @reservation.id)
      insert_tuple(:excluded_because_of_blackout_period,
                   :animal_id => Animal.random(:name => "blacked out").id,
                   :procedure_id => Procedure.random(:name => "used").id,
                   :first_date => @date, :last_date => @date,
                   :time_bits => "100",
                   :reservation_id => @reservation.id)
      assert_equal( {'unused procedure' => [], 'used' => []},
                    @availability_with_reservation.exclusions_due_to_reservations)
    end
  end

  context "exclusions due to animal kinds" do
    setup do 
      @procedure = Procedure.random(:name => "p")
      DB[:excluded_because_of_animal].insert(
                   :animal_id => Animal.random(:name => "animal").id,
                   :procedure_id => @procedure.id)
    end

    should "exclude procedures and animals that don't go together" do 
      assert_equal({'p' => ['animal']},
                   @availability.exclusions_due_to_animal)
    end

    should "not include animals already in use" do
      in_use = Animal.random(:name => "in use")
      DB[:excluded_because_of_animal].insert(
                   :animal_id => in_use.id,
                   :procedure_id => @procedure.id)
      insert_tuple(:excluded_because_in_use,
                   :animal_id => in_use.id,
                   :first_date => @date, :last_date => @date,
                   :time_bits => "100")
      assert_equal({'p' => ['animal']},
                   @availability.exclusions_due_to_animal)
    end
  end

  context "a kind map for animals" do 
    setup do 
      Animal.random(:name => "animal", :kind => "bovine")
    end

    should "be an animal-to-kind hash" do 
      assert_equal({'animal' => 'bovine'},
                   @availability.kind_map)
    end

    should "include animals already in use" do
      # Because animals already in use are displayed when a reservation is being edited.
      in_use = Animal.random(:name => "in use", :kind => 'equine')
      insert_tuple(:excluded_because_in_use,
                   :animal_id => in_use.id,
                   :first_date => @date, :last_date => @date,
                   :time_bits => "100")
      assert_equal({'animal' => 'bovine',
                    'in use' => 'equine'},
                   @availability.kind_map)
    end

    should "not include animals out of service" do
      in_use = Animal.random(:name => "in use", 
                             :date_removed_from_service => @timeslice.first_date - 30)
      insert_tuple(:excluded_because_in_use,
                   :animal_id => in_use.id,
                   :first_date => @date, :last_date => @date,
                   :time_bits => "100")
      assert_equal({'animal' => 'bovine'},
                   @availability.kind_map)
    end
  end

  context "animals that can be taken out of service" do 
    should "include animals that have never been reserved" do 
      Animal.random(:name => "animal")
      assert_equal(["animal"], 
                    @availability.animals_that_can_be_removed_from_service)
    end

    should "include animals that have been reserved prior to beginning of timeslice" do 
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use").id,
                   :first_date => @date-2, :last_date => @date-1)
      assert_equal(["in use"], 
                    @availability.animals_that_can_be_removed_from_service)
    end

    should "reject animals reserved in an overlapping timeslice" do 
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use").id,
                   :first_date => @date-2, :last_date => @date,
                   :time_bits => "001") # not intersecting
      assert_equal([], 
                    @availability.animals_that_can_be_removed_from_service)
    end

    should "reject animals reserved in later timeslice" do 
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use").id,
                   :first_date => @date+100, :last_date => @date+101)
      assert_equal([], 
                    @availability.animals_that_can_be_removed_from_service)
    end

    should "even if earlier reserved..." do 
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use").id,
                   :first_date => @date-1, :last_date => @date-1)
      insert_tuple(:excluded_because_in_use,
                   :animal_id => Animal.random(:name => "in use").id,
                   :first_date => @date+100, :last_date => @date+101)
      assert_equal([], 
                    @availability.animals_that_can_be_removed_from_service)
    end


    should "reject animals taken out of service already" do
      Animal.random(:name => "animal", :date_removed_from_service => @date)
      # including at a later date.
      Animal.random(:name => "animal", :date_removed_from_service => @date+1)
      assert_equal([], 
                    @availability.animals_that_can_be_removed_from_service)
    end
  end

  should "combine various methods in animals_and_procedures_and_exclusions" do 
    availability = flexmock(@availability, "partial availability mock")
    during { 
      availability.animals_and_procedures_and_exclusions
    }.behold! {
      availability.should_receive(:animals_that_can_be_reserved).at_least.once.
                   and_return("[animal name...]")
      availability.should_receive(:procedures_that_can_be_assigned).at_least.once.
                   and_return("[procedure name...]")
      availability.should_receive(:kind_map).at_least.once.
                   and_return("{animal name => kind...}")
      availability.should_receive(:exclusions_due_to_reservations).at_least.once.
                   and_return("{procedure => [name...]...}")
      availability.should_receive(:exclusions_due_to_animal).at_least.once.
                   and_return("another {procedure => [name...]...}")
    }
    assert_equal({ :animals => "[animal name...]",
                   :procedures => "[procedure name...]",
                   :kindMap => "{animal name => kind...}",
                   :timeSensitiveExclusions => "{procedure => [name...]...}",
                   :timelessExclusions => "another {procedure => [name...]...}"
                 },
                 @result)
    
  end
end

