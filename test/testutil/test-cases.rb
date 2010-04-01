
class FreshDatabaseTestCase < Test::Unit::TestCase
  require 'test/testutil/db-helpers'
  include DBHelpers
  def default_test; 'silence test::unit whining about missing tests'; end

  def setup
    empty_tables
  end
end


class EndToEndTestCase < FreshDatabaseTestCase
  require 'model/requires'
  require 'controller/base'
  require 'test/testutil/end-to-end-util'

  include Rack::Test::Methods
  attr_reader :app

  def setup
    super
    @app = Controller.new
    @app.authorizer = AuthorizeEverything.new
  end

  def default_test; 'silence test::unit whining about missing tests'; end
end
