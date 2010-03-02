$: << '../../..' unless $in_rake
require 'test/testutil/requires'
require 'model/excluders/requires'
require 'model/requires'

class ProcedureBlackoutPeriodExcluderTests < FreshDatabaseTestCase
  def setup
    super
    @date=Date.new(2009, 12, 12)
    @time = AFTERNOON
  end
  
  def typical_use(ignored_reservation = Reservation.acts_as_empty)
    timeslice = Timeslice.degenerate(@date, @time, ignored_reservation)
    excluder = ProcedureBlackoutPeriodExcluder.new
    excluder.as_map(timeslice)
  end 

  context "procedures with zero-day intervals" do
    # This does NOT apply to such intervals
    should_eventually "mean no overlap for an animal that's used on a different day" do
      Reservation.random(:date => @date+1,
                         :time => @time) do
        use Animal.random
        use Procedure.random(:name => 'proc', :days_delay => 0)
      end
      assert_equal([], typical_use[Procedure[:name=>'proc']])
    end

    should_eventually "mean no overlap for an animal that's used earlier today" do
      Reservation.random(:date => @date,
                         :time => MORNING) do
        use Animal.random
        use Procedure.random(:name => 'proc', :days_delay => 0)
      end
      assert_equal([], typical_use[Procedure[:name=>'proc']])
    end

    should_eventually "mean no overlap for an animal that's used at SAME TIME" do
      # Must be handled by different code.
      Reservation.random(:date => @date,
                         :time => AFTERNOON) do
        use Animal.random
        use Procedure.random(:name => 'proc', :days_delay => 0)
      end
      assert_equal([], typical_use[Procedure[:name=>'proc']])
    end
  end

  context "longer intervals" do
    context "with animals used in the past" do 
      setup do
        @recent =  Animal.random(:name => 'recent')
        @proc = Procedure.random(:name => 'proc', :days_delay => 15)
        @reservation = Reservation.random(:date => @date-1,
                                          :time => MORNING,
                                          :animal => @recent,
                                          :procedure => @proc)
      end

      should_eventually "exclude animals within that interval" do
        assert_equal([@recent], typical_use[Procedure[:name=>'proc']])
      end

      # This could happen if a reservation is being edited and the date/time
      # is being changed. 
      should_eventually "not exclude animals in reservation to be ignored" do
        assert_equal([], typical_use(@reservation)[Procedure[:name=>'proc']])
      end
    end

    context "with animals used in the future" do 
      setup do
        @near_future =  Animal.random(:name => 'near future')
        @proc = Procedure.random(:name => 'proc', :days_delay => 15)
        @reservation = Reservation.random(:date => @date+3,
                                          :time => MORNING,
                                          :animal => @near_future,
                                          :procedure => @proc)
      end

      should_eventually "exclude animals within that interval" do
        assert_equal([@near_future], typical_use[Procedure[:name=>'proc']])
      end

      # This could happen if a reservation is being edited and the date/time
      # is being changed. 
      should_eventually "not exclude animals in reservation to be ignored" do
        assert_equal([], typical_use(@reservation)[Procedure[:name=>'proc']])
      end
    end
  end
end


