$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class GroupTests < FreshDatabaseTestCase
  def setup
    super

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

  should "know the names of the animals within them" do
    Use.create(:animal => @fred, :procedure => @vaccination,
               :group => @group);
    Use.create(:animal => @betsy, :procedure => @vaccination,
               :group => @group);
    assert { @group.animal_names == ['betsy', 'fred'] }
  end

  should "know the names of the procedures within them" do
    Use.create(:animal => @betsy, :procedure => @vaccination,
               :group => @group);
    Use.create(:animal => @betsy, :procedure => @floating,
               :group => @group);
    assert { @group.procedure_names == ['floating', 'vaccination'] }
    
  end
end

