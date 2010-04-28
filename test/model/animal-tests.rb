$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class AnimalTests < FreshDatabaseTestCase

  context "the animal class" do 
    should "be able to return all animal names" do
      Animal.random_with_names('c', 'a', 'b')
      assert { Animal.names.sort == ['a', 'b', 'c'] }
    end

    should "be able to return sorted versions of names" do
      Animal.random_with_names('c', 'a', 'b')
      assert { Animal.sorted_names == ['a', 'b', 'c'] }
    end

    should "be able to do a case-insensitive lookup for names" do 
      expected = Animal.random(:name => "Cow")
      assert_equal(expected, Animal.with_case_insensitive_name("cow"))
    end
  end

  context "animal instances" do 

    # Tested because PostGres 8.3 and 8.4 behave differently for
    # method names with underscores in them (I think). Result is that
    # on 8.3, Animal.columns does not include :procedure_description_kind.
    # 
    should "be able to return a procedure description kind" do
      a = Animal.random(:name => 'bossie', :kind => 'cow', :procedure_description_kind => 'bovine')
      assert { 'bovine' ==  a.procedure_description_kind }
    end

    should "be able to remove from scheduling as of a date" do
      animal = Animal.random
      animal.remove_from_service_as_of('2001-12-01')
      
      actual_date = Animal[animal.id].date_removed_from_service
      assert { Date.parse('2001-12-01') == actual_date } 
    end

    should "be able to tell when in service" do 
      still_in = Animal.random.remove_from_service_as_of('2001-12-02')
      out = Animal.random.remove_from_service_as_of('2001-12-01')
      never_removed = Animal.random

      test_date = Date.parse('2001-12-01')
      assert { still_in.in_service_on?(test_date) }
      deny { out.in_service_on?(test_date) } 
      assert { never_removed.in_service_on?(test_date) } 
    end

    context "an animal's pending reservations" do 
      setup do 
        @animal = animal = Animal.random
        @reservation = Reservation.random(:timeslice => Timeslice.new(Date.new(2009, 12, 2),
                                                                      Date.new(2009, 12, 3),
                                                                      TimeSet.new),
                                          :animal => animal,
                                          :procedure => Procedure.random)
      end

      should "be returned" do
        assert_equal([], @animal.reservations_pending_as_of(Date.new(2009,12,4)))
        assert_equal([@reservation],
                     @animal.reservations_pending_as_of(Date.new(2009,12,3)))
        assert_equal([@reservation],
                     @animal.reservations_pending_as_of(Date.new(2009,12,2)))
        assert_equal([@reservation],
                     @animal.reservations_pending_as_of(Date.new(2009,12,1)))
      end

      should ", alternately, be returned in the form of dates" do
        assert_equal([], @animal.dates_used_after_beginning_of(Date.new(2009,12,4)))
        assert_equal([Date.new(2009,12,03)],
                     @animal.dates_used_after_beginning_of(Date.new(2009,12,3)))
      end

      context "multiple reservations" do
        setup do
          @third = Reservation.random(:timeslice => Timeslice.new(Date.new(2010, 12, 3),
                                                                  Date.new(2010, 12, 3),
                                                                  TimeSet.new),
                                      :animal => @animal,
                                      :procedure => Procedure.random)
          @first = Reservation.random(:timeslice => Timeslice.new(Date.new(2020, 12, 3),
                                                                  Date.new(2020, 12, 3),
                                                                  TimeSet.new),
                                      :animal => @animal,
                                      :procedure => Procedure.random)
          @second = Reservation.random(:timeslice => Timeslice.new(Date.new(2011, 12, 3),
                                                                   Date.new(2011, 12, 3),
                                                                   TimeSet.new),
                                       :animal => @animal,
                                       :procedure => Procedure.random)
        end

        should "return reservations in descending date order" do
          assert_equal([@first, @second, @third, @reservation],
                       @animal.reservations_pending_as_of(Date.new(2009,12,3)))
        end

        should "return dates in descending order" do
          assert_equal([Date.new(2020,12,03), Date.new(2011,12,03),
                        Date.new(2010,12,03), Date.new(2009,12,03)],
                       @animal.dates_used_after_beginning_of(Date.new(2009,12,3)))
        end
      end
      
      context "multiple uses of animal within a reservation" do
        setup do
          Use.create(:animal => @animal, :procedure => Procedure.random,
                     :group => @reservation.groups.first)
        end
        
        should "only return one reservation" do
          assert_equal([@reservation], 
                       @animal.reservations_pending_as_of(Date.new(2009,12,3)))
        end

        should ", and one date" do
          assert_equal([Date.new(2009,12,03)],
                       @animal.dates_used_after_beginning_of(Date.new(2009,12,3)))
        end
      end
    end

    should "be sortable by lowercase name" do 
      z = Animal.random(:name => 'Z')
      m = Animal.random(:name => 'm')
      d = Animal.random(:name => 'd')
      a = Animal.random(:name => 'A')
      assert_equal([a, d, m, z],
                   [z, m, d, a].sort)
    end

  end
end

