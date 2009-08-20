$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ModelTests < Test::Unit::TestCase
  def setup
    empty_tables
  end

  context "procedures" do 
    should "collectively be able to return their names" do
      Procedure.random_with_names('c', 'a', 'b')
      assert { Procedure.names.sort == ['a', 'b', 'c'] }
    end
  end

  context "animals" do 
    should "collectively be able to return their names" do
      Animal.random_with_names('c', 'a', 'b')
      assert { Animal.names.sort == ['a', 'b', 'c'] }
    end

    should "be able to return a name=>kind mapping" do
      Animal.random(:name => 'bossie', :kind => 'cow')
      Animal.random(:name => 'fred', :kind => 'horse')
      assert { Animal.kind_map == {'bossie' => 'cow', 'fred' => 'horse'} }
    end
  end
end

