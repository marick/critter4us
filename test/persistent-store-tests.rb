require 'test/testutil/requires'
require 'test/testutil/config'

require 'persistent-store'
require 'admin/tables'
require 'model'

class PersistentStoreTests < Test::Unit::TestCase
  def setup
    empty_tables
  end


  should "return procedure names" do
    Procedure.create(:name => 'c')
    Procedure.create(:name => 'a')
    Procedure.create(:name => 'b')

    @store = PersistentStore.new
    
    assert { @store.procedure_names.sort == ['a', 'b', 'c'] }
  end

  should "return animal names" do
    Animal.create(:name => 'c')
    Animal.create(:name => 'a')
    Animal.create(:name => 'b')

    @store = PersistentStore.new
    
    assert { @store.all_animals.sort == ['a', 'b', 'c'] }
  end


end
