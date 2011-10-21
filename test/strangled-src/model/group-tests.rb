require './test/testutil/requires'
require './strangled-src/model/requires'

class GroupTests < FreshDatabaseTestCase
  def setup
    super

    @fred = Animal.random(:name => 'fred')
    @betsy = Animal.random(:name => 'betsy')
    @floating = Procedure.random(:name => 'floating')
    @vaccination = Procedure.random(:name => 'vaccination')
    @group = Group.create
  end

  should "know the animals within them" do
    Use.create(:animal => @fred, :procedure => @vaccination,
               :group => @group);
    Use.create(:animal => @betsy, :procedure => @floating,
               :group => @group);
    Use.create(:animal => @betsy, :procedure => @vaccination,
               :group => @group);
    assert { @group.animals.include?(@betsy) }
    assert { @group.animals.include?(@fred) }
  end

  should "know the names of the animals within them" do
    Use.create(:animal => @fred, :procedure => @vaccination,
               :group => @group);
    Use.create(:animal => @betsy, :procedure => @floating,
               :group => @group);
    Use.create(:animal => @betsy, :procedure => @vaccination,
               :group => @group);
    assert { @group.animal_names == ['betsy', 'fred'] }
  end

  should "know the procedures within them" do
    Use.create(:animal => @fred, :procedure => @vaccination,
               :group => @group);
    Use.create(:animal => @betsy, :procedure => @floating,
               :group => @group);
    Use.create(:animal => @betsy, :procedure => @vaccination,
               :group => @group);
    assert { @group.procedures.include?(@vaccination) }
    assert { @group.procedures.include?(@floating) }
  end

  should "know the names of the procedures within them" do
    Use.create(:animal => @betsy, :procedure => @vaccination,
               :group => @group);
    Use.create(:animal => @betsy, :procedure => @floating,
               :group => @group);
    assert { @group.procedure_names == ['floating', 'vaccination'] }
    
  end
end

