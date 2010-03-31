$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'


# TODO: Needs fixing to be compatible with caching of exclusions in new database tables.

class SevenAndOneDayExampleOfBlackoutPeriodTests < FreshDatabaseTestCase
  def setup
    super
    @venipuncture = Procedure.random(:name => 'venipuncture', :days_delay => 7)
    @physical_exam = Procedure.random(:name => 'physical exam', :days_delay => 1)
    
    @veinie = Animal.random(:name => 'veinie')
    @bossie = Animal.random(:name => 'bossie')
    @staggers = Animal.random(:name => 'staggers')

    @eight31 = Reservation.random(:first_date => Date.new(2009, 8, 31),
                                  :last_date => Date.new(2009, 8, 31)) # Previous Monday
    @nine1 = Reservation.random(:first_date => Date.new(2009, 9, 1),
                                :last_date => Date.new(2009, 9, 1))  # Previous Tuesday
    @nine7 = Reservation.random(:first_date => Date.new(2009, 9, 7),
                                :last_date => Date.new(2009, 9, 7))  # Today, Monday

    
    only_eight31_group = Group.create(:reservation => @eight31)
    only_nine1_group = Group.create(:reservation => @nine1)
    only_nine7_group = Group.create(:reservation => @nine7)

    
    Use.create(:animal => @bossie, :procedure => @venipuncture,
               :group => only_eight31_group);
    Use.create(:animal => @staggers, :procedure => @venipuncture,
               :group => only_nine1_group);
    Use.create(:animal => @veinie, :procedure => @venipuncture,
               :group => only_nine7_group);
    Use.create(:animal => @veinie, :procedure => @physical_exam,
               :group => only_nine7_group)

    tuple_publisher = TuplePublisher.new
    tuple_publisher.note_reservation_exclusions(@eight31)
    tuple_publisher.note_reservation_exclusions(@nine1)
    tuple_publisher.note_reservation_exclusions(@nine7)
  end

  def typical_use(date, time, ignored_reservation = Reservation.acts_as_empty)
    timeslice = Timeslice.degenerate(date, time)
    Availability.new(timeslice, ignored_reservation.id).exclusions_due_to_reservations
  end

  should "find excluded animals for tomorrow" do 
    hash = typical_use(Date.new(2009, 9, 8), MORNING)
    assert_equal(['veinie'], hash['venipuncture'])
    assert_equal([], hash['physical exam'])
  end

  should "find excluded animals for next Sunday" do 
    hash = typical_use(Date.new(2009, 9, 13), MORNING)
    assert_equal(['veinie'], hash['venipuncture'])
    assert_equal([], hash['physical exam'])
  end

  should "find excluded animals for next Monday" do 
    hash = typical_use(Date.new(2009, 9, 14), MORNING)
    assert_equal([], hash['venipuncture'])
    assert_equal([], hash['physical exam'])
  end

  should "find excluded animals for today" do 
    hash = typical_use(Date.new(2009, 9, 7), MORNING)
    assert_equal(['staggers', 'veinie'], hash['venipuncture'])
    assert_equal(['veinie'], hash['physical exam'])
  end

  should "find excluded animals when last week's reservation is to be moved to today" do
    hash = typical_use(Date.new(2009, 9, 7), MORNING, @nine1)
    assert_equal(['veinie'], hash['venipuncture'])
    assert_equal(['veinie'], hash['physical exam'])
  end

  should "find excluded animals when earliest reservation is moved up two days" do
    hash = typical_use(Date.new(2009, 9, 2), MORNING, @eight31)
    assert_equal(['staggers', 'veinie'], hash['venipuncture'])
    assert_equal([], hash['physical exam'])
  end

  should "find excluded animals when moving today's reservation to tomorrow" do
    hash = typical_use(Date.new(2009, 8, 7), MORNING,  @nine7)
    assert_equal([], hash['venipuncture'])
    assert_equal([], hash['physical exam'])
  end
end


class DetailsAboutTimingTests < FreshDatabaseTestCase

    BoundaryCases = [
      # Reservation attempt for date after previously-made reservation
      # DELAY       USED-ON        TRY-AGAIN          OK?
[          0,       1, MORNING,     1, MORNING,        :NO ],        
[          0,       1, MORNING,     1, AFTERNOON,        :YES ],
[          0,       1, AFTERNOON,     1, EVENING,        :YES ],
[          0,       1, MORNING,     1, EVENING,        :YES ],

[          1,       1, MORNING,     1, AFTERNOON,      :NO ],
[          1,       1, MORNING,     1, EVENING,      :NO ],
[          1,       1, AFTERNOON,   2, MORNING,        :YES ],       
[          1,       1, EVENING,   2, MORNING,        :YES ],       

[          2,       1, AFTERNOON,   3, MORNING,        :YES ],
[          2,       1, EVENING,   3, MORNING,        :YES ],

      # Reservation attempt for date before previously-made reservation
      # DELAY       USED-ON        TRY-FOR-BEFORE          OK?
[          0,       1, AFTERNOON,   1, AFTERNOON,        :NO ],
[          0,       1, AFTERNOON,   1, MORNING,          :YES],
[          0,       1, EVENING,   1, AFTERNOON,          :YES],
[          0,       1, EVENING,   1, MORNING,          :YES],

[          1,       2, AFTERNOON,   2, AFTERNOON,        :NO],
[          1,       2, AFTERNOON,   2, MORNING,          :NO],  # no new info but just in case
[          1,       2, AFTERNOON,   1, AFTERNOON,        :YES],     
[          1,       2, MORNING,     1, MORNING  ,        :YES], # no new
[          1,       2, MORNING,     1, AFTERNOON,        :YES], # perhaps surprising
[          1,       2, MORNING,     1, EVENING,        :YES], # perhaps surprising

[          2,       3, AFTERNOON,   3, MORNING,          :NO],
[          2,       3, MORNING,     2, MORNING,          :NO],
[          2,       3, MORNING,     1, AFTERNOON,        :YES],
[          2,       3, AFTERNOON,     1, AFTERNOON,      :YES], # no new


[          7,       3, AFTERNOON,     1, AFTERNOON,      :NO], # no new
]

  def self.boundary_test(row, index)
    defn = %Q{
      def test_boundary_case_#{index}
        # puts "=========== boundary test #{index}"
        # puts #{row.inspect}.inspect
        boundary = BoundaryCases[#{index}]
        prior_reservation(*boundary[0,3])
        run_attempt(*boundary[3,2])
        assert_reservation_success(boundary.last)
      end
    }
    class_eval defn
  end

  BoundaryCases.each_with_index do | row, index |
    # puts "Skipping test #{row}, #{index}"
    boundary_test(row, index)
  end

  def excluded?(is_ok)
    is_ok == :NO
  end

  def prior_reservation(delay, date, time)
    @animal = Animal.random(:name => "bossie")
    @procedure = Procedure.random(:name => 'procedure', :days_delay => delay)
    @reservation = Reservation.random(:first_date => Date.new(2009, 12, date),
                                      :last_date => Date.new(2009, 12, date),
                                      :times => TimeSet.new(time))
    group = Group.create(:reservation => @reservation)
    @use = Use.create(:animal => @animal, :procedure => @procedure, :group => group)
    tuple_publisher = TuplePublisher.new
    tuple_publisher.note_reservation_exclusions(@reservation)
  end


  def run_attempt(attempt_date, attempt_time)
    # puts "attempt at #{[attempt_date, attempt_time].inspect}"
    @pairs = []
    timeslice = Timeslice.degenerate(Date.new(2009, 12, attempt_date), attempt_time)
    availability = Availability.new(timeslice, nil)
    @map = availability.exclusions_due_to_reservations
  end

  def assert_reservation_success(is_ok)
    if excluded?(is_ok)
      assert_equal([@animal.name], @map[@procedure.name])
    else
      assert_equal([], @map[@procedure.name])
    end
  end
end
