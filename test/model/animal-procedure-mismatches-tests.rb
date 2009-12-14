$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'ostruct'

class AnimalProcedureMismatchesTests < FreshDatabaseTestCase
  def setup
    super
    @date=Date.new(2009, 12, 12)
    @time = AFTERNOON
  end
  
  def typical_exclusion
    map_maker = AnimalProcedureMismatches.new
    map_maker.calculate
    map_maker.as_map(Procedure.all, Animal.all)
  end 

  should "exclude animals incompatible with a particular procedure" do
    horse_only_procedure = Procedure.create(:name => 'venipuncture')
    ExclusionRule.create(:procedure => horse_only_procedure, :rule => "HorsesOnly")
    
    horse = Animal.create(:name => 'horse', :procedure_description_kind => "equine")
    cow = Animal.create(:name => 'cow', :procedure_description_kind => "bovine")

    assert_equal([cow], typical_exclusion[horse_only_procedure])
  end
end
