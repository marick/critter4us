require './test/testutil/requires'

class SevenAndOneDayExampleOfBlackoutPeriodTests < EndToEndTestCase

  def setup
    super

    Procedure.random(:name => 'venipuncture', :days_delay => 7)
    Procedure.random(:name => 'physical exam', :days_delay => 1)
    
    Animal.random(:name => 'veinie')
    Animal.random(:name => 'bossie')
    Animal.random(:name => 'staggers')

    # Previous Monday
    @eight31 = make_reservation('2009-08-31', %w{bossie}, %w{venipuncture})
    # Previous Tuesday
    @nine1 = make_reservation('2009-09-01', %w{staggers}, %w{venipuncture})
    # Today, Monday
    @nine7 = make_reservation('2009-09-07', %w{veinie}, ['venipuncture', 'physical exam'])
  end

  def typical_use(date, time, ignored_reservation_id = nil)
    timeslice = Timeslice.degenerate(date, time)
    Availability.new(timeslice, ignored_reservation_id).exclusions_due_to_reservations
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
    hash = typical_use(Date.new(2009, 9, 8), MORNING,  @nine7)
    assert_equal([], hash['venipuncture'])
    assert_equal([], hash['physical exam'])
  end
end


class DetailsAboutTimingTests < FreshDatabaseTestCase
  include Rack::Test::Methods
  attr_reader :app

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
    @app = Controller.new
    @app.authorizer = AuthorizeEverything.new
    
    animal = Animal.random(:name => "bossie")
    procedure = Procedure.random(:name => 'procedure', :days_delay => delay)

    data = {
      'timeslice' => {
        'firstDate' => "2009-12-#{date}",
        'lastDate' => "2009-12-#{date}",
        'times' => [time]
      },
      'instructor' => 'morin',
      'course' => 'vm333',
      'groups' => [ {'procedures' => ['procedure'],
                      'animals' => ['bossie']} ]
      }.to_json

    post '/json/store_reservation', :reservation_data => data
  end


  def run_attempt(attempt_date, attempt_time)
    timeslice = Timeslice.degenerate(Date.new(2009, 12, attempt_date), attempt_time)
    availability = Availability.new(timeslice, nil)
    @map = availability.exclusions_due_to_reservations
  end

  def assert_reservation_success(is_ok)
    if excluded?(is_ok)
      assert_equal(['bossie'], @map['procedure'])
    else
      assert_equal([], @map['procedure'])
    end
  end
end
