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
      @app.override(mocks(:availability_source, :internalizer))
      availability = flexmock('availability')

      during { 
        get '/json/animals_that_can_be_taken_out_of_service', 'date' => '2009-01-01'
      }.behold! {
        @internalizer.should_receive(:make_timeslice_from_date).once.
                      with('2009-01-01').
                      and_return("timeslice")
        @availability_source.should_receive(:new).once.
                             with("timeslice").
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

      @data = {
        'firstDate' => '2009-02-03',
        'lastDate' => '2009-02-03',
        'times' => [MORNING],
        'instructor' => 'morin',
        'course' => 'vm333',
        'groups' => [ {'procedures' => ['lick', 'slop'],
                        'animals' => ['twitter', 'jinx']} ]
      }
    end

    should "create the required uses" do
      post '/json/store_reservation', :data => @data.to_json
      r = Reservation[:first_date => Date.new(2009, 02, 03)]
      assert { r.last_date == Date.new(2009, 02, 03) }
      assert { r.times == TimeSet.new(MORNING) }
      assert { r.instructor == @data['instructor'] }
      assert { r.course == @data['course'] }
      assert { r.groups.size == 1 }
      assert { r.uses.size == 4 }
      assert do 
        r.uses.find do | u | 
          u.animal.name == 'twitter' && u.procedure.name == 'slop'
        end
      end
    end

    should "return the reservation number as a string" do # {footnote 'string'}
      post '/json/store_reservation', :data => @data.to_json
      assert_json_response
      r = Reservation[:first_date => Date.new(2009, 02, 03)]
      assert_jsonification_of({'reservation' => r.pk.to_s})
    end
  end

  context "modifying a reservation" do 
    setup do 
      Animal.create(:name => 'twitter', :kind => 'sugar glider')
      Animal.create(:name => 'jinx', :kind => 'red-eared slider')
      Animal.create(:name => 'inchy', :kind => 'chinchilla')
      Procedure.random_with_names('floating', 'venipuncture', 'stroke')


      old_reservation_data = { 
        :instructor => 'marge',
        :course => 'vm333',
        :first_date => Date.new(2001, 2, 4),
        :last_date =>  Date.new(2001, 2, 4),
        :morning => true,
        :afternoon => true,
        :evening => true,
        :groups => [ {:procedures => ['floating'],
                       :animals => ['twitter']}]
      }
      old_reservation = Reservation.create_with_groups(old_reservation_data)
      @id_to_modify = old_reservation.pk.to_s

      incoming_modification_data = {
        'instructor' => 'morin',
        'course' => 'cs101',
        'firstDate' => '2011-11-11',
        'lastDate' => '2012-12-12',
        'times' => ['afternoon'],
        'groups' => [ ]
      }.to_json

      post '/json/modify_reservation', :reservationID => @id_to_modify,
                                       :data => incoming_modification_data

      @new_reservation = Reservation[@id_to_modify]
    end

    should "perform the update" do 
      # Spot check since the reservation does most of the work. 
      assert { @new_reservation.instructor == 'morin' }
      assert { @new_reservation.first_date == Date.new(2011, 11, 11) }
      assert { @new_reservation.last_date == Date.new(2012, 12, 12) }
      assert { @new_reservation.times == TimeSet.new(AFTERNOON) }
      assert { [] == @new_reservation.groups }
    end

    should "return the unchanged id" do 
      assert_json_response
      assert_jsonification_of({'reservation' => @new_reservation.pk.to_s})
      assert_equal @id_to_modify, @new_reservation.pk.to_s 
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

