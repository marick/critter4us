$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class TuplePublisherTests < FreshDatabaseTestCase
  def setup
    super
    @tuple_publisher = TuplePublisher.new
  end

  context "adding a new reservation" do 
    setup do 
      @common_data = { 
        :first_date => Date.new(2009, 1, 1),
        :last_date => Date.new(2009, 1, 2),
        :times => TimeSet.new(MORNING)
      }
    end

    should "add to the cache of animals in use" do
      r = Reservation.random(@common_data.merge(:animal => Animal.random(:name => "animal"),
                                                :procedure => Procedure.random))
      @tuple_publisher.add_reservation(r)

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

      @tuple_publisher.add_reservation(r)
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

      @tuple_publisher.add_reservation(r)
      assert(DB[:excluded_because_of_blackout_period].all.empty?)
    end
  end

end
