require './test/testutil/requires'
require './controller/base'
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
      @app.override(mocks(:date_source, :reservation_source))
      @app.test_view_builder = @dummy_view
      @today = Date.civil(2010, 4, 1)
      @expected_reservation = Reservation.random(:first_date => @today,
                                                 :last_date => @today,
                                                 :animal => Animal.random,
                                                 :procedure => Procedure.random)
    end

    should "require a specific number of days" do
      during { 
        get '/reservations/200'
      }.behold! {
        @date_source.should_receive(:today).once.and_return(@today)
        @reservation_source.should_receive(:since).once.
                            with(@today - 200).
                            and_return([@expected_reservation])
      }
      assert { @dummy_view[:reservations].size == 1 }
      actual_reservation = @dummy_view[:reservations].first
      assert { actual_reservation == @expected_reservation }
    end

    should "also let words to denote 'forever'" do
      during { 
        get '/reservations/gazillions'
      }.behold! {
        @date_source.should_receive(:today).once.and_return(@today)
        @reservation_source.should_receive(:since).once.
                            with(@today - 3650).
                            and_return([@expected_reservation])
      }
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
    should "coordinate deletion of reservations" do
      @app.override(mocks(:reservation_source, :tuple_publisher))

      during { 
        delete "/reservation/12/days_to_display_after_deletion"
      }.behold! {
        @reservation_source.should_receive(:erase).once.
                            with(12)
        @tuple_publisher.should_receive(:remove_reservation_exclusions).once.
                         with(12)
      }
    end

    should "redirect to reservations page" do
      @reservation = Reservation.random(:instructor => 'marge') do 
        use Animal.random
        use Procedure.random
      end
      assert { Reservation[:instructor => 'marge'] }
      delete "/reservation/#{@reservation.id}/days_to_display_after_deletion"
      assert { last_response.redirect? }
      assert { "/reservations/days_to_display_after_deletion" == last_response['Location'] }
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

  context "returning a table of animals with pending reservations" do 
    should "pass date and animal source to view" do
      @app.test_view_builder = @dummy_view
      get "/animals_with_pending_reservations?date=2009-08-03"
      assert_equal(Animal, @dummy_view[:animal_source])
      assert { Date.new(2009, 8, 3) == @dummy_view[:date] }
    end
  end

  context "getting a report on animals and procedures between two dates" do
    should "pass animal->procedure map to view" do 
      @app.test_view_builder = @dummy_view
      @app.override(mocks(:internalizer, :availability_source))
      availability = flexmock("availability")
      during {
        get "/animal_usage_report?firstDate=first&lastDate=last"
      }.behold! {
        @internalizer.should_receive(:make_timeslice_from_dates).
                      with("first", "last").
                      and_return("timeslice object")
        @availability_source.should_receive(:new).
                             with("timeslice object").
                             and_return(availability)
        availability.should_receive(:animal_usage).and_return("hash")
      }
      assert_equal("hash", @dummy_view[:data])
      assert_equal("timeslice object", @dummy_view[:timeslice])
    end
  end

end
