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

  context "animals" do 
    setup do 
      @date = Date.new(2010, 10, 10)
      @time = MORNING
      @fred = Animal.new(:name => 'fred')
    end

    context "in service at the timeslice moment" do 
      should "be cached" do
        @timeslice.move_to(@date, @time)
        during { 
          @timeslice.animals_in_service
          @timeslice.animals_in_service
          @timeslice.animals_in_service
          @timeslice.animals_in_service
        }.behold! {
          @animal_source.should_receive(:all_in_service_on).once.
                         with(@date).
                         and_return([@fred])
        }
          assert_equal([@fred], @result)
      end
    end

    context "that should be considered in use at the timeslice moment" do 
      setup do 
        @use_source.should_receive(:animals_in_use_at).once.
                    with(@date, @time).
                    and_return([@fred]).
                    by_default

      end

      should "normally be all those in use" do 
        @timeslice.move_to(@date, @time)
        assert_equal([@fred], @timeslice.animals_to_be_considered_in_use)
      end

      should "except that those from a given reservation will not be included" do 
        reservation = flexmock("reservation")
        @timeslice.move_to(@date, @time, ignoring = reservation)
        during { 
          @timeslice.animals_to_be_considered_in_use
        }.behold!{
          @use_source.should_receive(:animals_in_use_at).once.
                      with(@date, @time).
                      and_return([@fred])
          reservation.should_receive(:animals).once.
                     and_return([@fred])
        }
        assert_equal([], @result)
      end
    
      should "be cached" do 
        @timeslice.move_to(@date, @time)
        assert_equal([@fred], @timeslice.animals_to_be_considered_in_use)
        assert_equal([@fred], @timeslice.animals_to_be_considered_in_use)
        assert_equal([@fred], @timeslice.animals_to_be_considered_in_use)
        assert_equal([@fred], @timeslice.animals_to_be_considered_in_use)
        assert_equal([@fred], @timeslice.animals_to_be_considered_in_use)
      end
    end
    
    context "that are available for reservation" do 
      setup do 
        @betsy = Animal.new(:name => 'betsy')
        @animal_source.should_receive(:all_in_service_on).once.
                       with(@date).
                       and_return([@betsy, @fred]).
                       by_default
        @use_source.should_receive(:animals_in_use_at).once.
                    with(@date, @time).
                    and_return([@fred]).
                    by_default
      end

      should "be returned if they are available at the timeslice moment" do
        @timeslice.move_to(@date, @time)
        assert_equal([@betsy], @timeslice.animals_that_can_be_reserved)
      end

      should "obey instructions to ignore a reservation" do
        reservation = flexmock("reservation")
        @timeslice.move_to(@date, @time, ignoring = reservation)
        during { 
          @timeslice.animals_that_can_be_reserved
        }.behold!{
          reservation.should_receive(:animals).once.
                      and_return([@fred])
        }
        assert_equal([@betsy, @fred], @result)
      end

      should "cache results" do 
        @timeslice.move_to(@date, @time)
        assert_equal([@betsy], @timeslice.animals_that_can_be_reserved)
        assert_equal([@betsy], @timeslice.animals_that_can_be_reserved)
        assert_equal([@betsy], @timeslice.animals_that_can_be_reserved)
        assert_equal([@betsy], @timeslice.animals_that_can_be_reserved)
      end
    end
  end

  context "maps from animals to their pending reservations (old)" do
    setup do
      @date = Date.new(2010, 10, 10)
      @brooke = brooke = Animal.random(:name => 'brooke')
      Reservation.random(:date => @date, :time => MORNING) do 
        use brooke
        use Procedure.random
      end
    end

    should "include animals used at timeslice" do
      @timeslice.move_to(@date, MORNING)
      result = @timeslice.hashes_from_animals_to_pending_dates([@brooke])
      assert { result == [{@brooke => [@date]}] }
    end
  end
end


class MockishTimesliceTests < Test::Unit::TestCase

  def setup
    @timeslice = Timeslice.new
  end

  context "maps from animals to their pending reservations (mockishly)" do
    setup do
      @date = Date.new(2010, 10, 10)
      @brooke = flexmock("brooke")
    end

    should "include animals used at timeslice (version 2)" do
      @timeslice.move_to(@date, MORNING)
      during { 
        @timeslice.hashes_from_animals_to_pending_dates([@brooke])
      }.behold! {
        @brooke.should_receive(:dates_used_after_beginning_of).once.
                with(@date).
                and_return(["dates brooke used"])
      }
      assert { @result == [ {@brooke => ["dates brooke used"]} ] }
    end
  end
end



