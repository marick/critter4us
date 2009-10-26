$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class AnimalTests < FreshDatabaseTestCase

  context "animals" do 
    should "individually be able to return a wire-format of self" do
      assert { Animal.random(:name => 'fred').in_wire_format == 'fred' }
    end

    should "collectively be able to return their names" do
      Animal.random_with_names('c', 'a', 'b')
      assert { Animal.names.sort == ['a', 'b', 'c'] }
    end

    should "collectively be able to return sorted versions of names" do
      Animal.random_with_names('c', 'a', 'b')
      assert { Animal.sorted_names == ['a', 'b', 'c'] }
    end

    should "be able to return a name=>kind mapping" do
      Animal.random(:name => 'bossie', :kind => 'cow')
      Animal.random(:name => 'fred', :kind => 'horse')
      assert { Animal.kind_map == {'bossie' => 'cow', 'fred' => 'horse'} }
    end

  end
end

