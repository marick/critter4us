$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ProcedureRulesTests < Test::Unit::TestCase

  def setup
    @procedure_rules = ProcedureRules.new(mocks(:procedure_source, 
                                                :animal_source))
  end

  should "use all rules for all procedures" do
    procedure = flexmock("procedure")
    rule = flexmock("rule")
    during {
      @procedure_rules.add_excluded_pairs("pairs")
    }.behold! { 
      @procedure_source.should_receive(:all).and_return([procedure])
      @animal_source.should_receive(:all).and_return("animals")
                                            
      procedure.should_receive(:rules).and_return([rule])
      rule.should_receive(:add_excluded_pairs).with("pairs", procedure, "animals")
    }
  end

end
