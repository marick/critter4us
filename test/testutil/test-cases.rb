require './test/testutil/fast-loading-test-cases'

class RackTestTestCase < FreshDatabaseTestCase
  require './src/routes/base'
  require './strangled-src/model/requires'
  require './src/routes/requires'
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
