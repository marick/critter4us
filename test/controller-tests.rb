require 'test/testutil/requires'
require 'controller'
require 'ostruct'

class HtmlControllerTests < Test::Unit::TestCase
  include Rack::Test::Methods

  attr_reader :app

  def setup
    empty_tables
    @app = Controller.new
    @dummy_view = TestViewClass.new
  end

  context "viewing reservations" do
    should "pass a list of reservations to the view" do
      DB.populate do
        @expected_reservation = Reservation.random do
          use(@expected_animal = Animal.random)
          use(@expected_procedure = Procedure.random)
        end
      end

      @app.test_view_builder = @dummy_view
      get '/reservations'
      assert { @dummy_view[:reservations].size == 1 }
      actual_reservation = @dummy_view[:reservations].first
      assert { actual_reservation == @expected_reservation }
    end
  end
end
