$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'ostruct'


class BasicProcedureOverlapTests < FreshDatabaseTestCase
  def setup
    super
    @date=Date.new(2009, 12, 12)
    @time = AFTERNOON
  end
  
  def typical_use(ignored_reservation = Reservation.acts_as_empty)
    procedure_overlaps = ProcedureOverlaps.new(@date, @time, ignored_reservation)
    procedure_overlaps.calculate
    hash = procedure_overlaps.as_map(Procedure, Animal)
  end 

  context "procedures with zero-day intervals" do
    # This does NOT apply to such intervals
    should "mean no overlap for an animal that's used on a different day" do
      Reservation.random(:date => @date+1,
                         :time => @time) do
        use Animal.random
        use Procedure.random(:name => 'proc', :days_delay => 0)
      end
      assert_equal([], typical_use[Procedure[:name=>'proc']])
    end

    should "mean no overlap for an animal that's used earlier today" do
      Reservation.random(:date => @date,
                         :time => MORNING) do
        use Animal.random
        use Procedure.random(:name => 'proc', :days_delay => 0)
      end
      assert_equal([], typical_use[Procedure[:name=>'proc']])
    end

    should "mean no overlap for an animal that's used at SAME TIME" do
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

      should "exclude animals within that interval" do
        assert_equal([@recent], typical_use[Procedure[:name=>'proc']])
      end

      # This could happen if a reservation is being edited and the date/time
      # is being changed. 
      should "not exclude animals in reservation to be ignored" do
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

      should "exclude animals within that interval" do
        assert_equal([@near_future], typical_use[Procedure[:name=>'proc']])
      end

      # This could happen if a reservation is being edited and the date/time
      # is being changed. 
      should "not exclude animals in reservation to be ignored" do
        assert_equal([], typical_use(@reservation)[Procedure[:name=>'proc']])
      end
    end
  end
end


class SevenAndOneDayExampleOfProcedureOverlapTests < FreshDatabaseTestCase
  def setup
    super
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

  def typical_use(date, time, ignored_reservation = Reservation.acts_as_empty)
    procedure_overlaps = ProcedureOverlaps.new(date, time, ignored_reservation)
    procedure_overlaps.calculate
    hash = procedure_overlaps.as_map(Procedure, Animal)
    
    # Sort to make comparisons easier.
    hash.each do | k, list | 
      list.sort! { | a, b, | a.name.downcase <=> b.name.downcase }
    end
  end

  should "find excluded animals for tomorrow" do 
    hash = typical_use(Date.new(2009, 9, 8), MORNING)
    assert_equal([@veinie], hash[@venipuncture])
    assert_equal([], hash[@physical_exam])
  end

  should "find excluded animals for next Sunday" do 
    hash = typical_use(Date.new(2009, 9, 13), MORNING)
    assert_equal([@veinie], hash[@venipuncture])
    assert_equal([], hash[@physical_exam])
  end

  should "find excluded animals for next Monday" do 
    hash = typical_use(Date.new(2009, 9, 14), MORNING)
    assert_equal([], hash[@venipuncture])
    assert_equal([], hash[@physical_exam])
  end

  should "find excluded animals for today" do 
    hash = typical_use(Date.new(2009, 9, 7), MORNING)
    assert_equal([@staggers, @veinie], hash[@venipuncture])
    assert_equal([@veinie], hash[@physical_exam])
  end

  should "find excluded animals when last week's reservation is to be moved to today" do
    hash = typical_use(Date.new(2009, 9, 7), MORNING, @nine1)
    assert_equal([@veinie], hash[@venipuncture])
    assert_equal([@veinie], hash[@physical_exam])
  end

  should "find excluded animals when earliest reservation is moved up two days" do
    hash = typical_use(Date.new(2009, 9, 2), MORNING, @eight31)
    assert_equal([@staggers, @veinie], hash[@venipuncture])
    assert_equal([], hash[@physical_exam])
  end

  should "find excluded animals when moving today's reservation to tomorrow" do
    hash = typical_use(Date.new(2009, 8, 7), MORNING,  @nine7)
    assert_equal([], hash[@venipuncture])
    assert_equal([], hash[@physical_exam])
  end
end
