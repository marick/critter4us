$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller/base'

class JsonGenerationTests < FreshDatabaseTestCase
  include Rack::Test::Methods

  attr_reader :app

  def setup
    super
    @app = Controller.new
    @app.authorizer = AuthorizeEverything.new
  end

  def assert_json_response
    assert { last_response['Content-Type'] == 'application/json' }
  end

  def assert_jsonification_of(ruby_obj)
    # pp JSON[last_response.body]
    assert_equal(ruby_obj, JSON[last_response.body])
  end

  def a_timeslice_having_first_date(datestring)
    on { | arg | 
      arg.first_date == Date.parse(datestring)
    }
  end


  context "delivering a blob of timeslice-specific animal and procedure data" do

    should "exclude animals that are currently in use" do 
      @app.override(mocks(:internalizer, :availability_source, :externalizer))
      availability = flexmock("availability")

      during { 
        params = { 'timeslice' => "timeslice hash",
                   'ignoring' => 'reservation id' }
        get '/json/animals_and_procedures_blob', params
            
      }.behold! {
        @internalizer.should_receive(:make_timeslice).once.
                      with("timeslice hash").
                      and_return("timeslice")
        @internalizer.should_receive(:integer_or_nil).once.
                      with("reservation id").
                      and_return("reservation")
        @availability_source.should_receive(:new).once.
                             with("timeslice", "reservation").
                             and_return(availability)

        availability.should_receive(:animals_and_procedures_and_exclusions).
                     and_return( {'some' => 'hash' } )
        @externalizer.should_receive(:convert).once.
                      with( {'some' => 'hash' }).
                      and_return({'some' => 'hash'}.to_json)
      }
      assert_json_response
      assert_jsonification_of({'some' => 'hash'})

    end
  end

  context "producing lists of animals in service" do 
    should "return a list of animals with no pending reservations" do 
      @app.override(mocks(:availability_source))
      availability = flexmock('availability')

      during { 
        get '/json/animals_that_can_be_taken_out_of_service', 'date' => '2009-01-01'
      }.behold! {
        @availability_source.should_receive(:new).once.
                             with(a_timeslice_having_first_date('2009-01-01')).
                             and_return(availability)
        availability.should_receive(:animals_that_can_be_removed_from_service).once.
                     and_return(['a list of animal names'])

      }

      assert_json_response
      assert_jsonification_of('unused animals' => ['a list of animal names'])
    end
  end

  context "taking animals out of service" do 
    setup do
      @data = {
        'date' => '2009-02-03',
        'animals' => ['betsy', 'jake']
      }

      Animal.random(:name => 'betsy')
      Animal.random(:name => 'jake')
      Animal.random(:name => 'fred')
    end

    should "remove the named animals as of the given date" do
      post '/json/take_animals_out_of_service', 'data' => @data.to_json
      
      assert_equal(Date.new(2009, 2, 3),
                   Animal[:name => 'betsy'].date_removed_from_service)
      assert_equal(Date.new(2009, 2, 3),
                   Animal[:name => 'jake'].date_removed_from_service)
      assert_equal(nil,
                   Animal[:name => 'fred'].date_removed_from_service)
    end
  end

  context "adding a reservation" do 
    setup do
      Animal.random_with_names('twitter', 'jinx')
      Procedure.random_with_names('lick', 'slop')

      @reservation_data = {
        'timeslice' => {
          'firstDate' => '2009-02-03',
          'lastDate' => '2009-02-03',
          'times' => [MORNING]
        },
        'instructor' => 'morin',
        'course' => 'vm333',
        'groups' => [ {'procedures' => ['lick', 'slop'],
                        'animals' => ['twitter', 'jinx']} ]
      }
      @jsonified_data = @reservation_data.to_json
    end


    should "coordinate creation of reservation" do 
      @app.override(mocks(:internalizer, :reservation_source, :tuple_publisher))
      reservation = flexmock("reservation", :id => 12)

      during { 
        post '/json/store_reservation', :reservation_data => @jsonified_data
      }.behold! {
        @internalizer.should_receive(:convert).once.
                      with('reservation_data' => @jsonified_data).
                      and_return(:reservation_data => @reservation_data)
        @reservation_source.should_receive(:create_with_groups).once.
                            with(@reservation_data).
                            and_return(reservation)
        @tuple_publisher.should_receive(:note_reservation_exclusions).once.
                         with(reservation)
      }

      assert_json_response
      assert_jsonification_of('reservation' => '12')
    end

    should "return the reservation number as a string" do # {footnote 'string'}
      post '/json/store_reservation', :reservation_data => @jsonified_data
      assert_json_response
      r = Reservation[:first_date => Date.new(2009, 02, 03)]
      assert_jsonification_of({'reservation' => r.id.to_s})
    end
  end

  context "modifying a reservation" do 
    should "coordinate other objects" do 
      @app.override(mocks(:internalizer, :reservation_source, :tuple_publisher))
      @reservation = flexmock("reservation", :id => 12)

      during {
        post '/json/modify_reservation', :reservationID => "12",
                                         :reservation_data => "json reservation data"
      }.behold! { 
        @internalizer.should_receive(:convert).once.
                      with("reservationID" => "12", "reservation_data" => "json reservation data").
                      and_return(:reservationID => 12, :reservation_data => "reservation data")
        @reservation_source.should_receive(:[]).once.
                            with(12).
                            and_return(@reservation)
        @reservation.should_receive(:update_with_groups).once.
                     with("reservation data")
        @tuple_publisher.should_receive(:remove_reservation_exclusions).once.
                         with(@reservation.id)
        @tuple_publisher.should_receive(:note_reservation_exclusions).once.
                         with(@reservation)
      }

      assert_json_response
      assert_jsonification_of({'reservation' => '12'})
    end
      


  end


  should "be able to retrieve a reservation and associated data" do 
    
    @app.override(mocks(:availability_source, :excluder, :internalizer))
    reservation = flexmock("reservation")
    availability = flexmock('availability')

    get_hash = {'number' => 'some_number', 'ignoring' => 'may be present'}
    during { 
      # Although the number argument is described in the get_hash, and is 
      # available in the params global in the controller, it has to 
      # be passed here so that the route-matching works.
      get '/json/reservation/some_number', get_hash
    }.behold! {
      @internalizer.should_receive(:find_reservation).once.
                    with(get_hash, 'number').
                    and_return(reservation)
      @internalizer.should_receive(:integer_or_nil).once.
                    with('may be present').
                    and_return("a reservation to ignore")
      reservation.should_receive(:timeslice).once.
                  and_return("a timeslice")
      @availability_source.should_receive(:new).once.
                  with("a timeslice", "a reservation to ignore").
                  and_return(availability)

      availability.should_receive(:animals_and_procedures_and_exclusions).once.
                   and_return({"availability" => "a result"})
      reservation.should_receive(:to_hash).once.
                   and_return({"reservation" => "r result"})
    }

    expected = { 'reservation' => 'r result',
                 'availability' => "a result"
    }
    assert_json_response
    assert_jsonification_of(expected)
  end

end

# {footnote 'string'}
#    The reservation ID (primary key) is an integer and could be returned as 
#    such. Code on the receiving side could treat it as either, since it's
#    just a token. It would probably want to treat it as a string, so there 
#    doesn't have to be logic to say "oh, this key here has an integer value so 
#    I will parse it". But then there's the possibility of confusion - why an int
#    on one side and a string on the other, so I'll just make it a string on both
#    sides.

