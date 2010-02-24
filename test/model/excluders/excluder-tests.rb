$: << '../../..' unless $in_rake
require 'test/testutil/requires'
require 'model/excluders/requires'
require 'model/requires'

class ExcluderTests < Test::Unit::TestCase
  def setup
    @timeslice = "an opaque object, so far as we're concerned"

    @betsy = Animal.new(:name => 'betsy')
    @jake = Animal.new(:name => 'jake')
    @physical = Procedure.new(:name => 'physical exam')
    @ai = Procedure.new(:name => 'artificial insemination')
    @procedures = [@physical, @ai]
  end

  should "manage collaborators" do
    during { 
      Excluder.new
    }.behold! {
      mocked_class(ReservedAnimalExcluder).should_receive(:new).once
      mocked_class(ProcedureBlackoutPeriodExcluder).should_receive(:new).once
      mocked_class(ConflictingAnimalExcluder).should_receive(:new).once
    }
  end

  context "fetching time-sensitive exclusions" do

    should "add the two collaborators together" do 
      excluder = Excluder.new
      excluder.override_collaborators_with(mocks(:in_blackout_period, :currently_reserved))

      during {
        excluder.time_sensitive_exclusions(@timeslice)
      }.behold! {
        @in_blackout_period.should_receive(:as_map).once.
                            with(@timeslice).
                            and_return({ @ai => [@betsy], 
                                         @physical => []
                                       })
        @currently_reserved.should_receive(:as_map).once.
                            with(@timeslice).
                            and_return({ @ai => [@jake],
                                         @physical => [@jake] 
                                       })
      }
    
      expected = { @ai => [@betsy, @jake],
                   @physical => [@jake] }
      assert_equal(expected, @result)
    end

    should "remove duplicates" do
      # Jake appears twice (though not possible in real life)
      excluder = Excluder.new
      excluder.override_collaborators_with(mocks(:in_blackout_period, :currently_reserved))

      during {
        excluder.time_sensitive_exclusions(@timeslice)
      }.behold! {
        @in_blackout_period.should_receive(:as_map).once.
                            with(@timeslice).
                            and_return({ @ai => [], 
                                         @physical => [@betsy, @jake]
                                       })
        @currently_reserved.should_receive(:as_map).once.
                            with(@timeslice).
                            and_return({ @ai => [],
                                         @physical => [@jake] 
                                       })
      }
    
      expected = { @ai => [],
                   @physical => [@betsy, @jake] }
      assert_equal(expected, @result)
    end
  end


  should "construct timeless exclusions from incompatible procedures and animals" do 
    excluder = Excluder.new
    excluder.override_collaborators_with(mocks(:procedure_animal_conflict))

    during {
      excluder.timeless_exclusions(@timeslice)
    }.behold! {
      @procedure_animal_conflict.should_receive(:as_map).once.
                                 with(@timeslice).
                                 and_return({ @ai => [@jake], 
                                              @physical => []
                                            })
    }
    
    expected = { @ai => [@jake],
                 @physical => [] }
    assert_equal(expected, @result)
  end
end
