$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ModelTests < Test::Unit::TestCase
  def setup
    empty_tables
  end

  context "procedures" do

    should "individually be able to return a wire-format of self" do
      assert { Procedure.random(:name => 'fred').in_wire_format == 'fred' }
    end

    should "collectively be able to return their names" do
      Procedure.random_with_names('c', 'a', 'b')
      assert { Procedure.names.sort == ['a', 'b', 'c'] }
    end

    
  end

  context "animals" do 
    should "individually be able to return a wire-format of self" do
      assert { Animal.random(:name => 'fred').in_wire_format == 'fred' }
    end

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

  context "groups" do 
    setup do 
      @fred = Animal.random(:name => 'fred')
      @betsy = Animal.random(:name => 'betsy')
      @floating = Procedure.random(:name => 'floating')
      @vaccination = Procedure.random(:name => 'vaccination')
      @group = Group.create
    end

    should "individually be able to return a wire-format of self" do
      Use.create(:procedure => @floating, :animal => @fred, :group => @group)
      assert { {'procedures' => ['floating'], 'animals' => ['fred']} ==
               @group.in_wire_format }
    end

    should "not have wire format fooled by duplication in uses" do
      Use.create(:procedure => @floating, :animal => @fred, :group => @group)
      Use.create(:procedure => @floating, :animal => @betsy, :group => @group)
      Use.create(:procedure => @vaccination, :animal => @fred, :group => @group)
      Use.create(:procedure => @vaccination, :animal => @betsy, :group => @group)
      expected = {
        'procedures' => ['floating', 'vaccination'],
        'animals' => ['betsy', 'fred']
      }
      assert { expected == @group.in_wire_format }
    end
  end
end

