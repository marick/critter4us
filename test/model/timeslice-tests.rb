$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'ostruct'

class TimesliceTests < FreshDatabaseTestCase

  def setup
    super
    @timeslice = Timeslice.new
    @timeslice.override(mocks(:animal_source, :procedure_source, :use_source))
    @destination = []
  end

  context "procedures" do 
    setup do 
      @procedure_source.should_receive(:all).once.
                        and_return([Procedure.new(:name => 'floating'),
                                    Procedure.new(:name => 'epidural'),
                                    Procedure.new(:name => 'Zygototomy'),
                                    Procedure.new(:name => "Caslick's procedure")
                                   ]).
                        by_default
    end
    
    should "be gotten from the procedure source" do
      @timeslice.procedures
    end

    should "be lazy" do 
      @timeslice.procedures
    end

    should "sort results" do
      assert_equal( ["Caslick's procedure", 'epidural', 'floating', 'Zygototomy'],
                    @timeslice.procedures.map(&:name))
    end
  end

  context "animals available" do 
    setup do 
      @date = Date.new(2010, 10, 10)
      @time = MORNING
      @fred = Animal.new(:name => 'fred')

      @animal_source.should_receive(:all_in_service_on).once.
                     with(@date).
                     and_return([@fred]).
                     by_default
      @use_source.should_receive(:animals_in_use_at).once.
                  with(@date, @time).
                  and_return([]).
                  by_default
    end

    should "be returned if they are available at the timeslice moment" do
      @timeslice.move_to(@date, @time)
      assert_equal([@fred], @timeslice.animals_at_all_available)
    end

    should "not be returned if they are in use at the timeslice moment" do
      @timeslice.move_to(@date, @time)
      during { 
        @timeslice.animals_at_all_available
      }.behold! {
        @use_source.should_receive(:animals_in_use_at).once.
                    with(@date, @time).
                    and_return([@fred])
      }
      assert_equal([], @result)
    end
    
    should "be included even when in use if timeslice asked to ignore their reservation" do
      reservation = flexmock("reservation")
      @timeslice.move_to(@date, @time, ignoring = reservation)
      during { 
        @timeslice.animals_at_all_available
      }.behold!{
        @use_source.should_receive(:animals_in_use_at).once.
                    with(@date, @time).
                    and_return([@fred])
        reservation.should_receive(:animals).once.
                    and_return([@fred])
      }
      assert_equal([@fred], @result)
    end
  end

  context "maps from animals to their pending reservations" do
    setup do
      @date = Date.new(2010, 10, 10)
      @brooke = brooke = Animal.random(:name => 'brooke')
      Reservation.random(:date => @date, :time => MORNING) do 
        use brooke
        use Procedure.random
      end
      @jake = Animal.random(:name => 'jake')
    end

    should "include animals used at timeslice" do
      @timeslice.move_to(@date, MORNING)
      result = @timeslice.hashes_from_animals_to_pending_dates([@brooke, @jake])
      assert { result.include?({@brooke => [@date]}) }
      assert { result.include?({@jake => []}) }
    end

    should "not include animals used before timeslice" do
      @timeslice.move_to(@date+1, MORNING)
      result = @timeslice.hashes_from_animals_to_pending_dates([@brooke, @jake])
      assert { result.include?({@brooke => []}) }
      assert { result.include?({@jake => []}) }
    end
  end


  # Most of the logic for exclusions is done by another object. The timeslice
  # is responsible for adding in animals that are currently in use.
  context "exclusions" do 
    setup do 
      @date=Date.new(2009, 12, 12)
      @time = MORNING
    end

    context "for animals in use during the timeslice moment" do 
      setup do
        @inuse = Animal.random(:name => "inuse")
        @procedure = Procedure.random(:name => 'lab procedure')
        @reservation = Reservation.random(:date => @date,
                                          :time => @time,
                                          :animal => @inuse,
                                          :procedure => @procedure)
        @other = Procedure.random(:name => 'other')
        @procedure_source.should_receive(:all).
                          and_return([@procedure, @other]).
                          by_default
        @animal_source.should_receive(:all_in_service_on).
                       with(@date).
                       and_return([@inuse]).
                       by_default
      end

      should "include the animal for all procedures" do
        @timeslice.move_to(@date, @time)
        during {
          @timeslice.exclusions
        }.behold! {
          @use_source.should_receive(:animals_in_use_at).
                      with(@date, @time).
                      and_return([@inuse])
        }
        assert_equal([@inuse], @result[@procedure])
        assert_equal([@inuse], @result[@other])
      end

      should "not count the animal if its reservation is ignored" do
        @timeslice.move_to(@date, @time, @reservation)
        during {
          @timeslice.exclusions
        }.behold! {
          @use_source.should_receive(:animals_in_use_at).
                      with(@date, @time).
                      and_return([@inuse])
        }
        assert_equal([], @result[@procedure])
        assert_equal([], @result[@other])
      end
    end
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
    boundary_test(row, index)
  end

  def excluded?(is_ok)
    is_ok == :NO
  end

  def prior_reservation(delay, date, time)
    @animal = Animal.random(:name => "bossie")
    @procedure = Procedure.random(:name => 'only', :days_delay => delay)
    @reservation = Reservation.random(:date => Date.new(2009, 12, date),
                                      :time => time)
    group = Group.create(:reservation => @reservation)
    @use = Use.create(:animal => @animal, :procedure => @procedure, :group => group)
  end


  def run_attempt(attempt_date, attempt_time)
    # puts "attempt at #{[attempt_date, attempt_time].inspect}"
    @pairs = []
    timeslice = Timeslice.new
    timeslice.move_to(Date.new(2009, 12, attempt_date), attempt_time)
    @map = timeslice.exclusions
  end

  def assert_reservation_success(is_ok)
    if excluded?(is_ok)
      assert_equal([@animal], @map[@procedure])
    else
      assert_equal([], @map[@procedure])
    end
  end
end
