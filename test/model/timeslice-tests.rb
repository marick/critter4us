$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'ostruct'


class TimesliceTests < Test::Unit::TestCase

  def setup
    mocks(:animal_source, :procedure_source, :use_source)
    @earlier_date = Date.new(2009, 9, 9)
    @later_date = Date.new(2009, 10, 10)
    @one_time = Set.new([MORNING])
    @two_times = Set.new([MORNING, EVENING])
    @fred = flexmock(:name => 'fred')
    @betsy = flexmock(:name => 'betsy')
  end

  def make_timeslice(first_date = Date.new(2009, 9, 9), 
                         last_date = Date.new(2009, 9, 9),
                         times = Set.new([MORNING]),
                         reservation = Reservation.acts_as_empty)
    timeslice = Timeslice.new(first_date, last_date, times, reservation)
    timeslice.override(:animal_source => @animal_source,
                       :procedure_source => @procedure_source,
                       :use_source => @use_source)
    timeslice
  end

  context "procedures" do 
    setup do 
      @timeslice = make_timeslice
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

    should "be cached" do 
      @timeslice.procedures
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
    end

    context "in service during the timeslice" do 
      should "be those in service on the last date" do
        @timeslice = make_timeslice(@earlier_date, @later_date)
        during { 
          @timeslice.animals_in_service
        }.behold! {
          @animal_source.should_receive(:all_in_service_on).once.
                         with(@later_date).
                         and_return([@fred])
        }
        assert_equal([@fred], @result)
      end

      should "be cached" do
        @timeslice = make_timeslice
        during { 
          @timeslice.animals_in_service
          @timeslice.animals_in_service
          @timeslice.animals_in_service
        }.behold! {
          @animal_source.should_receive(:all_in_service_on).once.
                         and_return("something irrelevant to this test")
        }
      end
    end

    context "that should be considered in use in the timeslice" do 

      should "normally be all those in use between the two dates" do 
        timeslice = make_timeslice
        during {
          timeslice.animals_to_be_considered_in_use
        }.behold! {
          @use_source.should_receive(:animals_in_use_during).once.
                      with(timeslice).
                      and_return([@fred])
        }
        assert_equal([@fred], @result)
      end

      should "except that those from a given reservation will not be included" do 
        reservation = flexmock("reservation")
        timeslice = make_timeslice('irrelevant', 'irrelevant', 'irrelevant', reservation)
        during { 
          timeslice.animals_to_be_considered_in_use
        }.behold!{
          @use_source.should_receive(:animals_in_use_during).once.
                      with(timeslice).
                      and_return([@fred])
          reservation.should_receive(:animals).once.
                     and_return([@fred])
        }
        assert_equal([], @result)
      end
    
      should "be cached" do 
        timeslice = make_timeslice
        during { 
          assert_equal([@fred], timeslice.animals_to_be_considered_in_use)
          assert_equal([@fred], timeslice.animals_to_be_considered_in_use)
          assert_equal([@fred], timeslice.animals_to_be_considered_in_use)
          assert_equal([@fred], timeslice.animals_to_be_considered_in_use)
          assert_equal([@fred], timeslice.animals_to_be_considered_in_use)
        }.behold! {
          @use_source.should_receive(:animals_in_use_during).once.
                      and_return([@fred])
        }
      end
    end
    
    context "that are available for reservation" do 
      setup do 
        @animal_source.should_receive(:all_in_service_on).once.
                       and_return([@betsy, @fred])
        @use_source.should_receive(:animals_in_use_during).once.
                    and_return([@fred])
      end

      should "be returned if they are available at the timeslice" do
        timeslice = make_timeslice('irrelevant', 'irrelevant')
        assert_equal([@betsy], timeslice.animals_that_can_be_reserved)
      end

      should "obey instructions to ignore a reservation" do
        reservation = flexmock("reservation")
        @timeslice = make_timeslice('irrelevant', 'irrelevant', 'irrelevant', ignoring = reservation)
        during { 
          @timeslice.animals_that_can_be_reserved
        }.behold!{
          reservation.should_receive(:animals).once.
                      and_return([@fred])
        }
        assert_equal([@betsy, @fred], @result)
      end

      should "cache results" do 
        timeslice = make_timeslice
        assert_equal([@betsy], timeslice.animals_that_can_be_reserved)
        assert_equal([@betsy], timeslice.animals_that_can_be_reserved)
        assert_equal([@betsy], timeslice.animals_that_can_be_reserved)
        assert_equal([@betsy], timeslice.animals_that_can_be_reserved)
      end
    end
  end

  context "maps from animals to the last date of their pending reservations (mockishly)" do
    should "include animals used at timeslice" do
      timeslice = make_timeslice(@earlier_date, @later_date)
      during { 
        timeslice.hashes_from_animals_to_pending_dates([@betsy])
      }.behold! {
        @betsy.should_receive(:dates_used_after_beginning_of).once.
                with(@later_date).
                and_return(["dates betsy used"])
      }
      assert { @result == [ {@betsy => ["dates betsy used"]} ] }
    end
  end
end



