$: << '../../..' unless $in_rake
require 'test/testutil/requires'
require 'model/excluders/requires'
require 'model/requires'

class ConflictingAnimalExcluderTests < FreshDatabaseTestCase

  def setup
    @horse_only_procedure = Procedure.create(:name => 'venipuncture')
    ExclusionRule.create(:procedure => @horse_only_procedure, :rule => "HorsesOnly")
    
    @horse = Animal.create(:name => 'horse', :procedure_description_kind => "equine")
    @cow = Animal.create(:name => 'cow', :procedure_description_kind => "bovine")

    @timeslice = flexmock('timeslice')
  end

  should "exclude animals incompatible with a particular procedure" do
    excluder = ConflictingAnimalExcluder.new(@timeslice)

    during { 
      excluder.as_map
    }.behold! {
      @timeslice.should_receive(:procedures).at_least.once.
                 and_return([@horse_only_procedure])
      @timeslice.should_receive(:animals_in_service).once.
                 and_return([@cow, @horse])
    }
    assert_equal({@horse_only_procedure => [@cow]}, @result)
  end
end
