$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class TimesliceTests < FreshDatabaseTestCase

  def setup
    super
    @timeslice = Timeslice.new
    @destination = []
  end

  context "adding pairs excluded at a given time" do

    setup do 
      @date=Date.new(2009, 12, 12)
      @morning = true
      @timeslice.move_to(@date, @morning)
    end
    
    should "include the null case" do 
      @destination = ['...'] # starts with some contents.
      Procedure.random(:name => 'only', :days_delay => 14)
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination == ['...'] }
    end

    should "include ALL procedures for an animal being used somewhere during the timeslice" do
      inuse = Animal.random(:name => "inuse")
      procedure = Procedure.random(:name => 'lab procedure')
      Reservation.random(:date => @date,
                         :morning => @morning) do
        use inuse
        use procedure
      end
      other = Procedure.random(:name => 'other')


      @timeslice.add_excluded_pairs(@destination)
      assert { @destination.count == 2 }
      assert { @destination.include?([other, inuse]) }
      assert { @destination.include?([procedure, inuse]) }
    end


    should "not exclude an animal that's used for a 0-delay procedure on a different day" do
      Reservation.random(:date => @date+1,
                         :morning => @morning) do
        use Animal.random
        use Procedure.random(:name => 'proc', :days_delay => 0)
      end
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination == [] }
    end

    should "not exclude an animal that's used for a 0-delay procedure earlier today" do
      @timeslice.move_to(@date, morning = false)
      Reservation.random(:date => @date,
                         :morning => true) do
        use Animal.random
        use Procedure.random(:name => 'proc', :days_delay => 0)
      end
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination == [] }
    end


    should "exclude an animal if that animal has been used for the same procedure too recently" do
      recent =  Animal.random(:name => 'recent')
      proc = Procedure.random(:name => 'proc', :days_delay => 15)
      Reservation.random(:date => @date-1,
                         :morning => true) do
        use recent
        use proc
      end
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination == [[proc, recent]] }
    end

    should "exclude an animal if procedure withholding time would overlap an existing reservation" do
      near_future =  Animal.random(:name => 'near future')
      proc = Procedure.random(:name => 'proc', :days_delay => 15)
      Reservation.random(:date => @date+3,
                         :morning => true) do
        use near_future
        use proc
      end
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination == [[proc, near_future]] }
    end
  end

  context "typical example of 7 and 1 day exclusion" do 

    setup do 
      @venipuncture = Procedure.random(:name => 'venipuncture', :days_delay => 7)
      @physical_exam = Procedure.random(:name => 'physical exam', :days_delay => 1)
      
      @veinie = Animal.random(:name => 'veinie')
      @bossie = Animal.random(:name => 'bossie')
      @staggers = Animal.random(:name => 'staggers')

      eight31 = Reservation.random(:date => Date.new(2009, 8, 31)) # Previous Monday
      nine1 = Reservation.random(:date => Date.new(2009, 9, 1))  # Previous Tuesday
      nine7 = Reservation.random(:date => Date.new(2009, 9, 7))  # Today, Monday

      
      only_eight31_group = Group.create(:reservation => eight31)
      only_nine1_group = Group.create(:reservation => nine1)
      only_nine7_group = Group.create(:reservation => nine7)

      
      Use.create(:animal => @bossie, :procedure => @venipuncture,
                 :group => only_eight31_group);
      Use.create(:animal => @staggers, :procedure => @venipuncture,
                 :group => only_nine1_group);
      Use.create(:animal => @veinie, :procedure => @venipuncture,
                 :group => only_nine7_group);
      Use.create(:animal => @veinie, :procedure => @physical_exam,
                 :group => only_nine7_group)
    end

    should "handle scheduling for today" do 
      @timeslice.move_to(Date.new(2009, 9, 7), true)
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination.include?([@venipuncture, @staggers]) }
      assert { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      assert { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end

    should "handle scheduling for tomorrow" do 
      @timeslice.move_to(Date.new(2009, 9, 8), true)
      @timeslice.add_excluded_pairs(@destination)
      deny { @destination.include?([@venipuncture, @staggers]) }
      assert { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      deny { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end

    should "handle scheduling for next Sunday" do 
      @timeslice.move_to(Date.new(2009, 9, 13), true)
      @timeslice.add_excluded_pairs(@destination)
      deny { @destination.include?([@venipuncture, @staggers]) }
      assert { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      deny { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end

    should "handle scheduling for next Monday" do 
      @timeslice.move_to(Date.new(2009, 9, 14), true)
      @timeslice.add_excluded_pairs(@destination)
      deny { @destination.include?([@venipuncture, @staggers]) }
      deny { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      deny { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end
  end


  should_eventually "allow animals to be included despite being in use (e.g., if editing reservation)" do 
    during {
      @timeslice.exclusions(:allowing_animals => ['fred'])
    }.behold! { 
      @procedure_source.should_receive(:names).once.
                        and_return(procedure_names = 'a list of procedure names')
      @use_source.should_receive(:combos_unavailable_at).with(@date, @morning).once.
                  and_return([['floating', 'fred'], ['veni', 'betsy']])
      @hash_maker.should_receive(:keys_and_pairs).once.
                  with(procedure_names, [['veni', 'betsy']]).
                  and_return('a hash')
    }
    assert { @result == 'a hash' }
  end

  should "deliver animal names not in use during the timeslice" do
    date = Date.new(2010, 10, 10)
    morning = true
    cannot_be_used = Animal.random(:name => "cannot be used")
    can_be_used = Animal.random(:name => "can be used")
    procedure = Procedure.random(:name => 'lab procedure')
    Reservation.random(:date => date,
                       :morning => morning) do
      use cannot_be_used
      use procedure
    end
    Reservation.random(:date => date,
                       :morning => !morning) do
      use can_be_used
      use procedure
    end

    @timeslice.move_to(date, morning)
    result = @timeslice.available_animals_by_name
    assert { result == ['can be used'] }
  end
end

class DetailsAboutTimingTests < FreshDatabaseTestCase

    BoundaryCases = [
      # Reservation attempt for date after previously-made reservation
      # DELAY       USED-ON        TRY-AGAIN          OK?
[          0,       1, :morning,     1, :morning,        :NO ],        # 1
[          0,       1, :morning,     1, :afternoon,        :YES ],

[          1,       1, :morning,     1, :afternoon,      :NO ],
[          1,       1, :afternoon,   2, :morning,        :YES ],       # 4

[          2,       1, :afternoon,   3, :morning,        :YES ],

      # Reservation attempt for date before previously-made reservation
      # DELAY       USED-ON        TRY-FOR-BEFORE          OK?
[          0,       1, :afternoon,   1, :afternoon,        :NO ],
[          0,       1, :afternoon,   1, :morning,          :YES],

[          1,       2, :afternoon,   2, :afternoon,        :NO],
[          1,       2, :afternoon,   2, :morning,          :NO],  # no new info but just in case
[          1,       2, :afternoon,   1, :afternoon,        :YES],     # 10
[          1,       2, :morning,     1, :morning  ,        :YES], # no new
[          1,       2, :morning,     1, :afternoon,        :YES], # perhaps surprising

[          2,       3, :afternoon,   3, :morning,          :NO],
[          2,       3, :morning,     2, :morning,          :NO],
[          2,       3, :morning,     1, :afternoon,        :YES],
[          2,       3, :afternoon,     1, :afternoon,      :YES], # no new


[          7,       3, :afternoon,     1, :afternoon,      :NO], # no new
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
                                      :morning => (time == :morning))
    group = Group.create(:reservation => @reservation)
    @use = Use.create(:animal => @animal, :procedure => @procedure, :group => group)
  end


  def run_attempt(attempt_date, attempt_time)
    # puts "attempt at #{[attempt_date, attempt_time].inspect}"
    @pairs = []
    timeslice = Timeslice.new
    timeslice.move_to(Date.new(2009, 12, attempt_date),
                      attempt_time == :morning)
    timeslice.add_excluded_pairs(@pairs)
  end

  def assert_reservation_success(is_ok)
    expected = excluded?(is_ok) ? [[@procedure, @animal]] : []
    # puts "actual: #{@pairs}"
    # puts "expected: #{expected}"
    assert { @pairs == expected }
  end
end
