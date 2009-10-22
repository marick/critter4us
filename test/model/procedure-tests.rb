$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ProcedureTests < FreshDatabaseTestCase
  should "individually be able to return a wire-format of self" do
    assert { Procedure.random(:name => 'fred').in_wire_format == 'fred' }
  end

  should "collectively be able to return their names" do
    Procedure.random_with_names('c', 'a', 'b')
    assert { Procedure.names.sort == ['a', 'b', 'c'] }
  end

  should "collectively be able to return names, sorted" do
    Procedure.random_with_names('c', 'a', 'b')
    assert { Procedure.sorted_names == ['a', 'b', 'c'] }
  end

  should "be able to return instances of rules" do
    proc = Procedure.random(:name => 'floating')
    DB[:exclusion_rules].insert(:procedure_id => proc.id,
                                :rule => 'HorsesOnly')
    assert { proc.exclusion_rules.length == 1 } 
    assert { proc.exclusion_rules.first.is_a? Rule::HorsesOnly } 
  end
end

