require './test/testutil/requires'
require './strangled-src/model/requires'

class TuplePublisherTests < FreshDatabaseTestCase
  def setup
    super
    @tuple_publisher = TuplePublisher.new

    @common_data = { 
      :first_date => Date.new(2009, 1, 1),
      :last_date => Date.new(2009, 1, 2),
      :times => TimeSet.new(MORNING)
    }
  end

  context "noting creation of a new reservation" do 
    should "add to the cache of animals in use" do
      r = Reservation.random(@common_data.merge(:animal => Animal.random(:name => "animal"),
                                                :procedure => Procedure.random))
      @tuple_publisher.note_reservation_exclusions(r)

      actual = DB[:excluded_because_in_use].first
      assert_equal(r.first_date, actual[:first_date])
      assert_equal(r.last_date, actual[:last_date])
      assert_equal(r.times.bits, actual[:time_bits])
      assert_equal(r.id, actual[:reservation_id])
      assert_equal('animal', Animal[actual[:animal_id]].name)
    end

    # See also blackout-period-confirmatory-tests.rb

    should "add to the blackout period cache" do
      animal = Animal.random(:name => "animal")
      procedure = Procedure.random(:name => "proc", :days_delay => 2)
      r = Reservation.random(@common_data.merge(:animal => animal, :procedure => procedure))

      @tuple_publisher.note_reservation_exclusions(r)
      actual = DB[:excluded_because_of_blackout_period].first

      assert_equal(r.first_date - 1, actual[:first_date])
      assert_equal(r.last_date + 1, actual[:last_date])
      assert_equal(r.times.bits, actual[:time_bits])
      assert_equal(r.id, actual[:reservation_id])
      assert_equal(animal.id, actual[:animal_id])
      assert_equal(procedure.id, actual[:procedure_id])
    end

    should "not add procedures without blackouts" do
      animal = Animal.random(:name => "animal")
      procedure = Procedure.random(:name => "proc", :days_delay => 0)
      r = Reservation.random(@common_data.merge(:animal => animal, :procedure => procedure))

      @tuple_publisher.note_reservation_exclusions(r)
      assert(DB[:excluded_because_of_blackout_period].all.empty?)
    end
  end

  context "deleting reservations" do
    setup do 
      r = Reservation.random(@common_data.merge(:animal => Animal.random(:name => "animal"),
                                                :procedure => Procedure.random))
      @id = r.id
      @tuple_publisher.note_reservation_exclusions(r)
      assert { DB[:excluded_because_of_blackout_period].count > 0 }
      assert { DB[:excluded_because_in_use].count > 0 }
    end

    should "delete match" do 
      @tuple_publisher.remove_reservation_exclusions(@id)
      assert { DB[:excluded_because_of_blackout_period].count == 0 }
      assert { DB[:excluded_because_in_use].count == 0 }
    end

    should "not delete mismatches" do 
      @tuple_publisher.remove_reservation_exclusions(@id+1)
      assert { DB[:excluded_because_of_blackout_period].count > 0 }
      assert { DB[:excluded_because_in_use].count > 0 }
    end
  end

end
