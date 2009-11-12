$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller'
require 'ostruct'

class HtmlControllerTests < FreshDatabaseTestCase
  include Rack::Test::Methods

  attr_reader :app

  def setup
    super
    @app = Controller.new
    @app.authorizer = AuthorizeEverything.new
    @dummy_view = TestViewClass.new
  end

  context "viewing reservations" do
    setup do 
      @expected_reservation = Reservation.random do
        use(@expected_animal = Animal.random)
        use(@expected_procedure = Procedure.random)
      end
    end

    should "pass a list of reservations to the view" do
      @app.test_view_builder = @dummy_view
      get '/reservations'
      assert { @dummy_view[:reservations].size == 1 }
      actual_reservation = @dummy_view[:reservations].first
      assert { actual_reservation == @expected_reservation }
    end
  end

  context "viewing animals" do
    setup do
      Animal.random(:name => 'bossy', :kind => 'cow', :procedure_description_kind => 'bovine')
      Animal.random(:name => 'jake', :kind => 'gelding', :procedure_description_kind => 'equine')
      
    end

    should "pass a list of animals to the view" do
      @app.test_view_builder = @dummy_view
      get '/animals'
      actual_names = @dummy_view[:animals].map(&:name) 
      assert { actual_names == ['bossy', 'jake'] }
    end
  end

  context "deleting reservations" do
    setup do 
      @reservation = Reservation.random(:instructor => 'marge') do 
        use Animal.random
        use Procedure.random
      end
      assert { Reservation[:instructor => 'marge'] }
    end

    should "be able to delete reservations" do
      delete "/reservation/#{@reservation.id}"

      deny { Reservation[:instructor => 'marge'] }
    end

    should "redirect to reservations page" do
      delete "/reservation/#{@reservation.id}"
      follow_redirect!
      assert_equal "http://example.org/reservations", last_request.url
      assert last_response.ok?        
    end
  end
end
