$LOAD_PATH.unshift('..')
require 'testutil/requires'
require 'testutil/config'

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
end
