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
end

