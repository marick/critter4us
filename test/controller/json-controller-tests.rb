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
      @app.override(mocks(:animal_source, :excluder, :internalizer))
      timeslice = flexmock(timeslice)

      get_hash = {'timeslice' => {'contents' => 'irrelevant for this test'}.to_json}
      during { 
        get '/json/animals_and_procedures_blob', get_hash
      }.behold! {
        @internalizer.should_receive(:find_reservation).once.
                      with(get_hash, 'ignoring').
                      and_return('a reservation to ignore')
        @internalizer.should_receive(:make_timeslice).once.
                      with(get_hash['timeslice'], 'a reservation to ignore').
                      and_return(timeslice)

        timeslice.should_receive(:animals_that_can_be_reserved).once.
                  and_return('some animals')
        timeslice.should_receive(:procedures).once.
                   and_return('some sorted procedures')
        @animal_source.should_receive(:kind_map).once.
                       and_return('some kind map')
        @excluder.should_receive(:time_sensitive_exclusions).once.
                  with(timeslice).
                  and_return('some time-sensitive exclusions')
        @excluder.should_receive(:timeless_exclusions).once.
                  with(timeslice).
                  and_return('some time-independent exclusions')
      }

      expected = {
         'animals' => 'some animals',
         'procedures' => 'some sorted procedures',
         'kindMap' => 'some kind map',
         'timeSensitiveExclusions' => 'some time-sensitive exclusions',
         'timelessExclusions' => 'some time-independent exclusions',
      }
      assert_json_response
      assert_jsonification_of(expected)
    end
  end

  context "producing lists of animals in service" do 
    should "return a list of animals with no pending reservations" do 
      @app.override(mocks(:animal_source, :internalizer))
      timeslice = flexmock("timeslice")
      brooke = Animal.random(:name => 'brooke')
      jake = Animal.random(:name => 'jake')

      get_hash = {'date' => '2009-01-01'}
      during { 
        get '/json/animals_that_can_be_taken_out_of_service', get_hash
      }.behold! {
        @internalizer.should_receive(:make_timeslice_from_date).once.
                      with(get_hash['date']).
                      and_return(timeslice)
        timeslice.should_receive(:animals_that_can_be_reserved).once.
                  and_return([brooke, jake])
        timeslice.should_receive(:hashes_from_animals_to_pending_dates).once.
                  with([brooke, jake]).
                  and_return([{brooke => [Date.new(2009,1,1), Date.new(2010,1,1)]},
                              {jake => []}])
      }
      assert_json_response
      assert_jsonification_of('unused animals' => ['jake'])
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
    
    @app.override(mocks(:animal_source, :excluder, :internalizer))
    reservation = flexmock("reservation")
    timeslice = flexmock('timeslice')

    get_hash = {'number' => 'some_number', 'ignoring' => 'may be present'}
    during { 
      # Although the number argument is described in the get_hash, and is 
      # available in the params global in the controller, it has to 
      # be passed here so that the route-matching works.
      get '/json/reservation/some_number', get_hash
    }.behold! {
      @internalizer.should_receive(:find_reservation).once.
                    with(get_hash, 'ignoring').
                    and_return('a reservation to ignore')
      @internalizer.should_receive(:find_reservation).once.
                    with(get_hash, 'number').
                    and_return(reservation)
      reservation.should_receive(:timeslice).once.
                  with('a reservation to ignore').
                  and_return(timeslice)

      reservation.should_receive(:instructor).once.and_return('instructor')
      reservation.should_receive(:course).once.and_return('course')
      reservation.should_receive(:first_date).once.and_return(Date.new(2001,1,1))
      reservation.should_receive(:last_date).once.and_return(Date.new(2002,2,2))
      reservation.should_receive(:times).once.and_return(TimeSet.new(MORNING))
      reservation.should_receive(:groups).once.and_return('groups')
      reservation.should_receive(:pk).once.and_return(5)

      timeslice.should_receive(:procedures).once.
                 and_return('some sorted procedures')
      timeslice.should_receive(:animals_that_can_be_reserved).once.
                and_return('some animals')
      @animal_source.should_receive(:kind_map).once.
                     and_return('some kind map')
      @excluder.should_receive(:time_sensitive_exclusions).once.
                with(timeslice).
                and_return('some time-sensitive exclusions')
      @excluder.should_receive(:timeless_exclusions).once.
                with(timeslice).
                and_return('some time-independent exclusions')
    }

    expected = {
      'instructor' => 'instructor',
      'course' => 'course',
      'firstDate' => '2001-01-01',
      'lastDate' => '2002-02-02',
      'times' => ['morning'],
      'groups' => 'groups',
      'id' => '5',
      'animals' => 'some animals',
      'procedures' => 'some sorted procedures',
      'kindMap' => 'some kind map',
      'timeSensitiveExclusions' => 'some time-sensitive exclusions',
      'timelessExclusions' => 'some time-independent exclusions',
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

