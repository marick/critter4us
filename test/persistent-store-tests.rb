require 'test/testutil/requires'
require 'test/testutil/config'

require 'persistent-store'
require 'admin/tables'
require 'model'

class PersistentStoreTests < Test::Unit::TestCase
  def setup
    empty_tables
    @store = PersistentStore.new
  end


  should "return procedure names" do
    Procedure.create(:name => 'c')
    Procedure.create(:name => 'a')
    Procedure.create(:name => 'b')
    
    assert { @store.procedure_names.sort == ['a', 'b', 'c'] }
  end

  should "return animal names" do
    Animal.create(:name => 'c')
    Animal.create(:name => 'a')
    Animal.create(:name => 'b')

    assert { @store.all_animals.sort == ['a', 'b', 'c'] }
  end

  context "exclusions" do
    should "have empty exclusion list if no uses" do 
      Procedure.create(:name => 'only', :days_delay => 14)
      Animal.create(:name => "bossie");

      expected = { 'only' => [] }
      assert { @store.exclusions_for_date(Date.new(2009, 7, 23)) == expected }
    end


    puts "Note: not sure how boundaries are handled."

    should "have empty exclusion list if outside delay" do 
      procedure = Procedure.create(:name => 'only', :days_delay => 1)
      animal = Animal.create(:name => "bossie");
      Use.create(:animal => animal, :procedure => procedure,
                 :date => Date.new(2002, 12, 1))

      expected = { 'only' => [] }
      assert { @store.exclusions_for_date(Date.new(2002, 12, 3)) == expected }
    end

    should "have excluded animal if within delay" do 
      procedure = Procedure.create(:name => 'only', :days_delay => 2)
      animal = Animal.create(:name => "bossie");
      Use.create(:animal => animal, :procedure => procedure,
                 :date => Date.new(2002, 12, 1))

      expected = { 'only' => ['bossie'] }
      assert { @store.exclusions_for_date(Date.new(2002, 12, 2)) == expected }
    end

  end
end
