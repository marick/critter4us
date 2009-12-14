$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'ostruct'

class AnimalProcedureConflictsTests < FreshDatabaseTestCase
  def setup
    super
    @date=Date.new(2009, 12, 12)
    @time = AFTERNOON
  end
  
  def typical_use
    map_maker = AnimalProcedureMismatches.new
    map_maker.calculate
    map_maker.as_map(Procedure.all, Animal.all)
  end 

  should "exclude animals incompatible with a particular procedure" do
    procedure = Procedure.create(:name => 'venipuncture')
    ExclusionRule.create(:procedure => procedure, :rule => "HorsesOnly")
    
    horse = Animal.create(:name => 'horse', :procedure_description_kind => "equine")
    cow = Animal.create(:name => 'cow', :procedure_description_kind => "bovine")

    assert_equal([horse], typical_use[procedure])
  end
end
