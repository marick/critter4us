$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller/base'
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

    should "pass an animal source and date source to the view" do
      @app.test_view_builder = @dummy_view
      get '/animals'
      assert { Animal == @dummy_view[:animal_source] }
      assert { @dummy_view[:date_source].is_a? DateSource } 
    end
  end

  context "deleting reservations" do
    setup do 
      @reservation = Reservation.random(:instructor => 'marge') do 
        use Animal.random
        use Procedure.random
      end
      assert { Reservation[:instructor => 'marge'] }
      delete "/reservation/#{@reservation.id}"
    end

    should "be able to delete reservations" do
      deny { Reservation[:instructor => 'marge'] }
    end

    should "redirect to reservations page" do
      follow_redirect!
      assert last_response.ok?        
      assert_equal "http://example.org/reservations", last_request.url
    end
  end


  context "deleting animals" do
    setup do 
      @animal = Animal.random
      deny { Animal[@animal.id].date_removed_from_service }
      delete "/animal/#{@animal.id}?as_of=2012-03-30"
    end

    should "be able to delete animals" do
      actual_effective_date = Animal[@animal.id].date_removed_from_service
      assert { Date.parse('2012-03-30') == actual_effective_date }
    end

    should "redirect to animals page" do
      follow_redirect!
      assert last_response.ok?        
      assert_equal "http://example.org/animals", last_request.url
    end
  end

end
