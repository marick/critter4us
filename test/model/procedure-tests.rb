$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ProcedureTests < Test::Unit::TestCase
  def setup
    empty_tables
  end

  should "individually be able to return a wire-format of self" do
    assert { Procedure.random(:name => 'fred').in_wire_format == 'fred' }
  end

  should "collectively be able to return their names" do
    Procedure.random_with_names('c', 'a', 'b')
    assert { Procedure.names.sort == ['a', 'b', 'c'] }
  end

  should "be able to produce a local href name for itself" do
    procedure = Procedure.random(:name => 'c')
    assert { procedure.local_href == '#' + procedure.pk.to_s } 
  end

  should "be able to produce a nice filename without special characters" do
    procedure = Procedure.random(:name => "a procedure");
    assert { procedure.filename == "a_procedure" }
    procedure = Procedure.random(:name => "Caslick's procedure (horses)");
    assert { procedure.filename == "Caslicks_procedure_horses" }
  end

end

