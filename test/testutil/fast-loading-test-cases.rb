require 'test/unit'
require 'shoulda'
require 'assert2'
require 'flexmock'
require 'ostruct'
require './admin/tables'
require './src/functional/functional_hash'
require './src/db/database_structure'

class FreshDatabaseTestCase < Test::Unit::TestCase
  require './test/testutil/db-helpers'
  include DBHelpers
  include FHUtil
  include DatabaseStructure

  def default_test; 'silence test::unit whining about missing tests'; end

  def setup
    empty_tables
  end
end

class ViewTestCase < FreshDatabaseTestCase
  def default_test; 'silence test::unit whining about missing tests'; end

  def setup
    super
    # This, behind the scenes, is needed for the renderer.
    # The assignment isn't strictly needed. It's there to keep you from
    # wondering "What about garbage collection?"
    @hack_to_objectify_views = Controller.new
    @renderer = Renderer.new
  end

end


 
