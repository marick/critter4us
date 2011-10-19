class FreshDatabaseTestCase < Test::Unit::TestCase
  require './test/testutil/db-helpers'
  include DBHelpers
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


class RackTestTestCase < FreshDatabaseTestCase
  require './model/requires'
  require './controller/base'
  include Rack::Test::Methods
  include HtmlAssertions

  attr_reader :app

  def setup
    super
    @app = Controller.new
    real_controller.authorizer = AuthorizeEverything.new
  end

  def default_test; 'silence test::unit whining about missing tests'; end
  
  def assert_redirect_to (where)
    assert { last_response.redirect? }
    assert { %r{#{where}$} =~ last_response['Location'] }
  end

end

class EndToEndTestCase < RackTestTestCase
  require './test/testutil/end-to-end-util'

  def default_test; 'silence test::unit whining about missing tests'; end
end
