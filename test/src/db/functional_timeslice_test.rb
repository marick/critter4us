require './test/testutil/fast-loading-requires'
require './src/db/functional_timeslice'
require './src/db/full_reservation'
require './strangled-src/model/requires'
require 'base64'
require 'json'

class FunctionalTimesliceTest < FreshDatabaseTestCase

  should "convert in from_browser format" do
    original = {
      :first_date => "2009-7-23",
      :last_date => "2010-8-24",
      :times => ["morning"]
    }
    encoded = Base64.encode64(original.to_json)
    timeslice = FunctionalTimeslice.from_browser(encoded)
    assert { timeslice.class == FunctionalTimeslice }
    assert { timeslice.first_date == Date.new(2009, 7, 23) }
    assert { timeslice.last_date == Date.new(2010, 8, 24) }
    assert { timeslice.time_bits == "100" }
  end

  should "read from reservation" do 
    old_format = Reservation.random(:timeslice => Timeslice.new(Date.new(2009, 7, 23),
                                                                Date.new(2009, 8, 24),
                                                                TimeSet.new(AFTERNOON)))
    new_format = FullReservation.from_id(old_format.id)
    
    timeslice = FunctionalTimeslice.from_reservation(new_format)
    assert { timeslice.class == FunctionalTimeslice }
    assert { timeslice.first_date == Date.new(2009, 7, 23) }
    assert { timeslice.last_date == Date.new(2009, 8, 24) }
    assert { timeslice.time_bits == "010" }
  end

  should "be able to shift by a number of days" do
    original = FunctionalTimeslice.from_time_data(Date.new(2001, 1, 2),
                                                  Date.new(2001, 1, 3),
                                                  "110")
    expected = FunctionalTimeslice.from_time_data(Date.new(2001, 1, 9),
                                                  Date.new(2001, 1, 10),
                                                  "110")
    actual = original.shift_by_days(7)
    assert { actual == expected }
  end

  def prepopulate_with_timeslices(dataset)
      @earlier = dataset.insert(  # no conflict
                                :first_date => Date.new(2001, 1, 1),
                                :last_date => Date.new(2001, 1, 1),
                                :time_bits => "111")
      @touching_before = dataset.insert(  # conflict
                                        :first_date => Date.new(2001, 1, 1),
                                        :last_date => Date.new(2001, 1, 2),
                                        :time_bits => "100")
      @time_bits_must_intersect = dataset.insert(  # no conflict
                                                 :first_date => Date.new(2001, 1, 2),
                                                 :last_date => Date.new(2001, 1, 3),
                                                 :time_bits => "001")
      @touching_after = dataset.insert(  # conflict
                                       :first_date => Date.new(2001, 1, 3),
                                       :last_date => Date.new(2001, 1, 5),
                                       :time_bits => "010")
      @later = dataset.insert(  # no conflict
                              :first_date => Date.new(2001, 1, 4),
                              :last_date => Date.new(2001, 1, 4),
                              :time_bits => "111")
  end


  context "exclusions" do 
    setup do 
      @timeslice = FunctionalTimeslice.from_time_data(Date.new(2001, 1, 2),
                                                      Date.new(2001, 1, 3),
                                                      "110")
    end

    should "be able to discover overlapping timeslices in a dataset" do
      prepopulate_with_timeslices(ExcludedBecauseInUse)
      overlaps = @timeslice.overlaps(ExcludedBecauseInUse)
      assert { overlaps.all? { | o | o.is_a?(FunctionalHash) } }

      deny { overlaps.any? { | tuple | tuple.id == @earlier } }
      assert { overlaps.any? { | tuple | tuple.id == @touching_before } }
      deny { overlaps.any? { | tuple | tuple.id == @time_bits_must_intersect } }
      assert { overlaps.any? { | tuple | tuple.id == @touching_after } }
      deny { overlaps.any? { | tuple | tuple.id == @later } }
    end

    should "be able to identify animals that are excluded" do
      prepopulate_with_timeslices(ExcludedBecauseInUse)
      excluded_animal = Animal.random.id
      kept_animal = Animal.random.id

      ExcludedBecauseInUse.filter(:id => @earlier).update(:animal_id => kept_animal)
      ExcludedBecauseInUse.filter(:id => @touching_before).update(animal_id: excluded_animal)
      ExcludedBecauseInUse.filter(:id => @time_bits_must_intersect).update(animal_id: kept_animal)
      ExcludedBecauseInUse.filter(:id => @touching_after).update(animal_id: excluded_animal)
      ExcludedBecauseInUse.filter(:id => @later).update(animal_id: kept_animal)

      assert { @timeslice.animal_ids_in_use == [excluded_animal] }
    end

    should "be able to identify uses that are excluded" do
      prepopulate_with_timeslices(ExcludedBecauseOfBlackoutPeriod)
      excluded_animal = Animal.random.id
      excluded_procedure = Procedure.random.id
      excluded_procedure_2 = Procedure.random.id

      excluded_1 = {animal_id: excluded_animal, procedure_id: excluded_procedure}
      excluded_2 = {animal_id: excluded_animal, procedure_id: excluded_procedure_2}

      ExcludedBecauseOfBlackoutPeriod.filter(id: @touching_before).update(excluded_1)
      ExcludedBecauseOfBlackoutPeriod.filter(:id => @touching_after).update(excluded_2)

      assert { Set.new(@timeslice.use_pairs_blacked_out) == Set.new([excluded_1, excluded_2]) }
    end

  end
end
