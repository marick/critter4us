require 'test/unit'
require 'shoulda'
require 'assert2'
require 'flexmock'
require 'ostruct'
require 'stunted'
require './admin/tables'
require './src/db/database_structure'

class FreshDatabaseTestCase < Test::Unit::TestCase
  include Stunted

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
    # In Sinatra, Controller.new doesn't actually give you the controller,
    # so I hackishly assign it to the class. 
    # The assignment isn't strictly needed. It's there to keep you from
    # wondering "What about garbage collection?"
    @hack_to_objectify_views = Controller.new
    @controller = Controller.actual_object
    @renderer = Renderer.new
  end

end


 
