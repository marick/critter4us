$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller'

class AuthorizationControllerTests < FreshDatabaseTestCase
  include Rack::Test::Methods

  attr_reader :app

  def setup
    super
    @app = Controller.new
    @dummy_view = TestViewClass.new
    @app.test_view_builder = @dummy_view
    @app.authorizer = @authorizer = flexmock("authorizer")
  end

  context "authorization" do
    should "try to authorize if not already authorized" do
      during {
        get '/'
      }.behold! {
        @authorizer.should_receive(:already_authorized?).and_return(false)
        @authorizer.should_receive(:authorize)
      }
    end

    should "not try to authorize if already authorized" do 
      during {
        get '/'
      }.behold! {
        @authorizer.should_receive(:already_authorized?).and_return(true);
      }
      assert { last_response.ok? }
    end

    should "be fine if authorization attempt succeeds" do
      during {
        get '/'
      }.behold! {
        @authorizer.should_receive(:already_authorized?).and_return(false)
        @authorizer.should_receive(:authorize).and_return(true)
      }
      assert { last_response.ok? }
    end

    should "show error if authorization attempt succeeds" do
      during {
        get '/'
      }.behold! {
        @authorizer.should_receive(:already_authorized?).and_return(false)
        @authorizer.should_receive(:authorize).and_return(false)
      }
      assert { last_response.status == 401 }
    end
  end
end




