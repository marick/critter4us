require './test/testutil/requires'

class AuthorizationControllerTests < FreshDatabaseTestCase
  include Rack::Test::Methods
  attr_reader :app

  def setup
    super
    @app = Controller.new
    real_controller.test_view_builder = TestViewClass.new
    real_controller.authorizer = @authorizer = flexmock("authorizer")
  end

  PROTECTED_PAGE='/protected_route_for_testing'

  context "authorization" do
    should "try to authorize if not already authorized" do
      during {
        result = get PROTECTED_PAGE
      }.behold! {
        @authorizer.should_receive(:already_authorized?).once.and_return(false)
        @authorizer.should_receive(:authorize).once
      }
    end

    should "not try to authorize if already authorized" do 
      during {
        get PROTECTED_PAGE
      }.behold! {
        @authorizer.should_receive(:already_authorized?).once.and_return(true);
      }
      assert { last_response.ok? }
    end

    should "be fine if authorization attempt succeeds" do
      during {
        get PROTECTED_PAGE
      }.behold! {
        @authorizer.should_receive(:already_authorized?).once.and_return(false)
        @authorizer.should_receive(:authorize).once.and_return(true)
      }
      assert { last_response.ok? }
    end

    should "show error if authorization attempt fails" do
      during {
        get PROTECTED_PAGE
      }.behold! {
        @authorizer.should_receive(:already_authorized?).once.and_return(false)
        @authorizer.should_receive(:authorize).once.and_return(false)
      }
      assert { last_response.status == 401 }
    end
 end
end




