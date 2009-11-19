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
      @time = MORNING
    end
    
    should "include the null case" do 
      @timeslice.move_to(@date, @time)
      @destination = ['...'] # starts with some contents.
      Procedure.random(:name => 'only', :days_delay => 14)
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination == ['...'] }
    end

    context "with an animal used during the timeslice" do 
      setup do
        @inuse = Animal.random(:name => "inuse")
        @procedure = Procedure.random(:name => 'lab procedure')
        @reservation = Reservation.random(:date => @date,
                                          :time => @time,
                                          :animal => @inuse,
                                          :procedure => @procedure)
        @other = Procedure.random(:name => 'other')
      end
      should "include ALL procedures for that animal" do
        @timeslice.move_to(@date, @time)
        @timeslice.add_excluded_pairs(@destination)
        assert { @destination.size == 2 }
        assert { @destination.include?([@other, @inuse]) }
        assert { @destination.include?([@procedure, @inuse]) }
      end


      should "not count the animal if its reservation is ignored" do
        @timeslice.move_to(@date, @time, @reservation)
        @timeslice.add_excluded_pairs(@destination)
        assert { @destination == [] }
      end
    end



    should "not exclude an animal that's used for a 0-delay procedure on a different day" do
      Reservation.random(:date => @date+1,
                         :time => @time) do
        use Animal.random
        use Procedure.random(:name => 'proc', :days_delay => 0)
      end
      @timeslice.move_to(@date, @time)
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination == [] }
    end

    should "not exclude an animal that's used for a 0-delay procedure earlier today" do
      Reservation.random(:date => @date,
                         :time => MORNING) do
        use Animal.random
        use Procedure.random(:name => 'proc', :days_delay => 0)
      end
      @timeslice.move_to(@date, time = AFTERNOON)
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination == [] }
    end


    context "with an animal that's been used for the same procedure too recently" do
      setup do
        @recent =  Animal.random(:name => 'recent')
        @proc = Procedure.random(:name => 'proc', :days_delay => 15)
        @reservation = Reservation.random(:date => @date-1,
                                          :time => MORNING,
                                          :animal => @recent,
                                          :procedure => @proc)
      end

      should "normally exclude" do
        @timeslice.move_to(@date, @time)
        @timeslice.add_excluded_pairs(@destination)
        assert { @destination == [[@proc, @recent]] }
      end

      # This could happen if a reservation is being edited and the date/time
      # is being changed. 
      should "not exclude if reservation to be ignored" do
        @timeslice.move_to(@date, @time, @reservation)
        @timeslice.add_excluded_pairs(@destination)
        assert { @destination == [] }
      end
    end


    context "with an existing reservation in the future" do 
      setup do 
        @near_future =  Animal.random(:name => 'near future')
        @proc = Procedure.random(:name => 'proc', :days_delay => 15)
        @reservation = Reservation.random(:date => @date+3,
                                          :time => MORNING,
                                          :animal => @near_future,
                                          :procedure => @proc)
      end

      should "normally exclude a pair" do
        @timeslice.move_to(@date, @time)
        @timeslice.add_excluded_pairs(@destination)
        assert { @destination == [[@proc, @near_future]] }
      end

      # This could happen if a reservation is being edited and the date/time
      # is being changed. 
      should "not exclude if the reservation is to be ignored" do
        @timeslice.move_to(@date, @time, @reservation)
        @timeslice.add_excluded_pairs(@destination)
        assert { @destination == [] }
      end
  end
end

  context "typical example of 7 and 1 day exclusion" do 

    setup do 
      @venipuncture = Procedure.random(:name => 'venipuncture', :days_delay => 7)
      @physical_exam = Procedure.random(:name => 'physical exam', :days_delay => 1)
      
      @veinie = Animal.random(:name => 'veinie')
      @bossie = Animal.random(:name => 'bossie')
      @staggers = Animal.random(:name => 'staggers')

      @eight31 = Reservation.random(:date => Date.new(2009, 8, 31)) # Previous Monday
      @nine1 = Reservation.random(:date => Date.new(2009, 9, 1))  # Previous Tuesday
      @nine7 = Reservation.random(:date => Date.new(2009, 9, 7))  # Today, Monday

      
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
    end

    should "handle scheduling for today" do 
      @timeslice.move_to(Date.new(2009, 9, 7), MORNING)
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination.include?([@venipuncture, @staggers]) }
      assert { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      assert { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end

    should "handle moving last week's reservation to today" do
      @timeslice.move_to(Date.new(2009, 9, 7), MORNING, @nine1)
      @timeslice.add_excluded_pairs(@destination)
      deny { @destination.include?([@venipuncture, @staggers]) } # part of @nine1
      assert { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      assert { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end

    should "handle moving earliest reservation up two days" do
      @timeslice.move_to(Date.new(2009, 9, 2), MORNING, @eight31)
      @timeslice.add_excluded_pairs(@destination)
      assert { @destination.include?([@venipuncture, @staggers]) }
      assert { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      deny { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end

    should "handle moving today's reservation to tomorrow" do
      @timeslice.move_to(Date.new(2009, 8, 7), MORNING,  @nine7)
      @timeslice.add_excluded_pairs(@destination)
      deny { @destination.include?([@venipuncture, @staggers]) }
      deny { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      deny { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end

    should "handle scheduling for tomorrow" do 
      @timeslice.move_to(Date.new(2009, 9, 8), MORNING)
      @timeslice.add_excluded_pairs(@destination)
      deny { @destination.include?([@venipuncture, @staggers]) }
      assert { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      deny { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end

    should "handle scheduling for next Sunday" do 
      @timeslice.move_to(Date.new(2009, 9, 13), MORNING)
      @timeslice.add_excluded_pairs(@destination)
      deny { @destination.include?([@venipuncture, @staggers]) }
      assert { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      deny { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end

    should "handle scheduling for next Monday" do 
      @timeslice.move_to(Date.new(2009, 9, 14), MORNING)
      @timeslice.add_excluded_pairs(@destination)
      deny { @destination.include?([@venipuncture, @staggers]) }
      deny { @destination.include?([@venipuncture, @veinie]) }
      deny { @destination.include?([@venipuncture, @bossie]) }
      deny { @destination.include?([@physical_exam, @veinie]) }
      deny { @destination.include?([@physical_exam, @staggers]) }
      deny { @destination.include?([@physical_exam, @bossie]) }
    end

  end


  context "delivering animal names" do 
    context "in the presence of reservations" do 
      setup do
        @date = Date.new(2010, 10, 10)
        @time = MORNING
        cannot_be_used = Animal.random(:name => "cannot be used")
        can_be_used = Animal.random(:name => "can be used")
        procedure = Procedure.random(:name => 'lab procedure')
        @cannot_be_used_reservation = Reservation.random(:date => @date,
                                                         :time => MORNING) do
          use cannot_be_used
          use procedure
        end
        Reservation.random(:date => @date,
                           :time => EVENING) do
          use can_be_used
          use procedure
        end
      end

      should "answer names of animals not in use during the timeslice" do
        @timeslice.move_to(@date, @time)
        result = @timeslice.available_animals_by_name
        assert { result == ['can be used'] }
      end

      should "override exclusion for a specific reservation's animals" do
        @timeslice.move_to(@date, @time,  @cannot_be_used_reservation)
        result = @timeslice.available_animals_by_name
        assert { result.sort == ['can be used', 'cannot be used'].sort }
      end
    end

    context "in the presence of animals removed from service" do 
      setup do 
        @date = Date.new(2010, 10, 10)
        @time = MORNING
        already_gone = Animal.random(:name => "already gone")
        already_gone.remove_from_service(@date)

        still_here = Animal.random(:name => "still here")
        still_here.remove_from_service(@date+1)
      end

      should "not return animals removed from service as of given date" do
        @timeslice.move_to(@date, @time)
        result = @timeslice.available_animals_by_name
        assert { result == ['still here'] }
      end
    end
  end
end

class DetailsAboutTimingTests < FreshDatabaseTestCase

    BoundaryCases = [
      # Reservation attempt for date after previously-made reservation
      # DELAY       USED-ON        TRY-AGAIN          OK?
[          0,       1, MORNING,     1, MORNING,        :NO ],        # 1
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
    timeslice.add_excluded_pairs(@pairs)
  end

  def assert_reservation_success(is_ok)
    expected = excluded?(is_ok) ? [[@procedure, @animal]] : []
    # puts "actual: #{@pairs}"
    # puts "expected: #{expected}"
    assert { @pairs == expected }
  end
end
