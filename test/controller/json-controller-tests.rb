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


  context "delivering a blob of course-session-specific data" do

    should "exclude animals that are currently in use" do 
      @app.override(mocks(:timeslice, :animal_source, :procedure_source,
                          :procedure_rules, :hash_maker))
      during { 
        get '/json/course_session_data_blob', {:date => '2009-01-01', :time => MORNING}
      }.behold! {
        @@stuff_that_always_happens.call
        @timeslice.should_receive(:move_to).once.with(Date.new(2009,1, 1), MORNING, nil)
      }
      assert_json_response
      assert_jsonification_of(@results_of_what_happens)
    end

    should "exclude animals that are currently in use (but ignoring a reservation)" do 
      reservation = Reservation.random(:date => Date.new(2009, 3, 3),
                                       :time => MORNING,
                                       :procedure => Procedure.random,
                                       :animal => Animal.random)
      @app.override(mocks(:timeslice, :animal_source, :procedure_source,
                          :procedure_rules, :hash_maker))
      during { 
        get "/json/course_session_data_blob",
            {:date => '2009-01-01', :time => MORNING, :ignoring => reservation.id}
      }.behold! {
        @@stuff_that_always_happens.call
        @timeslice.should_receive(:move_to).once.with(Date.new(2009,1, 1), MORNING, reservation)
      }
      assert_json_response
      assert_jsonification_of(@results_of_what_happens)
    end

    setup do
      @@stuff_that_always_happens = lambda() { 
        @timeslice.should_receive(:available_animals_by_name).once.and_return('some animals')
        @timeslice.should_receive(:procedure_names).once.and_return('some sorted procedure names')
        @timeslice.should_receive(:exclusions).once.
                   and_return('some exclusions')

        @animal_source.should_receive(:kind_map).once.and_return('some kind map')
      }

      @results_of_what_happens = {
         'animals' => 'some animals',
         'procedures' => 'some sorted procedure names',
         'kindMap' => 'some kind map',
         'exclusions' => 'some exclusions'
      }

    end



    # The following test predates mocks. They can continue to be used
    # but they're probably not worth fixing if they break.

    should "return a JSON list of strings" do
      Reservation.random(:date => Date.new(2009, 3, 3), :time => MORNING) do 
        use Procedure.random(:name => 'date mismatch procedure', :days_delay => 0)
        use Animal.random(:name => 'date mismatch animal', :kind => 'date mismatch kind')
      end
      
      Reservation.random(:date => Date.new(2009, 1, 1), :time => AFTERNOON) do 
        use Procedure.random(:name => 'time mismatch procedure', :days_delay => 1)
        use Animal.random(:name => 'time mismatch animal', :kind => 'time mismatch kind')
      end

      Reservation.random(:date => Date.new(2009, 1, 1), :time => MORNING) do
        use Procedure.random(:name => 'procedure', :days_delay => 3)
        use Animal.random(:name => 'animal', :kind => 'animal kind')
      end

      get '/json/course_session_data_blob', {:date => '2009-01-01', :time => MORNING}
      assert_json_response
      assert_jsonification_of({
         'procedures' => ['date mismatch procedure', 'procedure', 'time mismatch procedure'],
         'animals' => ['date mismatch animal', 'time mismatch animal'],
         'kindMap' => {'time mismatch animal' => 'time mismatch kind',
                       'date mismatch animal' => 'date mismatch kind',
                       'animal' => 'animal kind'},

        'exclusions' => { 'date mismatch procedure' => ['animal'],
                          'time mismatch procedure' => ['animal','time mismatch animal'],
                          'procedure' => ['animal'] }
         })
    end
  end

  context "producing lists of animals in service" do 
    should "return a list of animals with no pending reservations" do 
      @app.override(mocks(:animal_source, :timeslice))
      brooke = Animal.random(:name => 'brooke')
      jake = Animal.random(:name => 'jake')

      during { 
        get '/json/animals_in_service_blob', :date => '2009-01-01'
      }.behold! {
        @timeslice.should_receive(:move_to).once.with(Date.new(2009,1,1), MORNING, nil)
        @timeslice.should_receive(:available_animals).once.
                   and_return([brooke, jake])
        @timeslice.should_receive(:hashes_from_animals_to_pending_dates).once.
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
        'date' => '2009-02-03',
        'time' => MORNING,
        'instructor' => 'morin',
        'course' => 'vm333',
        'groups' => [ {'procedures' => ['lick', 'slop'],
                        'animals' => ['twitter', 'jinx']} ]
      }
    end

    should "create the required uses" do
      post '/json/store_reservation', :data => @data.to_json
      r = Reservation[:date => Date.new(2009, 02, 03)]
      assert { r.time == MORNING }
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
      r = Reservation[:date => Date.new(2009, 02, 03)]
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
        :date => Date.new(2001, 2, 4),
        :time => MORNING,
        :groups => [ {:procedures => ['floating'],
                       :animals => ['twitter']}]
      }
      old_reservation = Reservation.create_with_groups(old_reservation_data)
      @id_to_modify = old_reservation.pk.to_s

      incoming_modification_data = {
        'instructor' => 'morin',
        'course' => 'cs101',
        'date' => '2012-12-12',
        'time' => 'afternoon',
        'groups' => [ ]
      }.to_json

      post '/json/modify_reservation', :reservationID => @id_to_modify,
                                       :data => incoming_modification_data

      @new_reservation = Reservation[@id_to_modify]
    end

    should "perform the update" do 
      # Spot check since the reservation does most of the work. 
      assert { @new_reservation.instructor == 'morin' }
      assert { [] == @new_reservation.groups }
    end

    should "return the unchanged id" do 
      assert_json_response
      assert_jsonification_of({'reservation' => @new_reservation.pk.to_s})
      assert_equal @id_to_modify, @new_reservation.pk.to_s 
    end
  end

  context "retrieving a reservation" do
    setup do
      Animal.create(:name => 'twitter', :kind => 'sugar glider')
      Animal.create(:name => 'jinx', :kind => 'red-eared slider')
      Procedure.random_with_names('floating', 'venipuncture')
      test_data = { 
        :instructor => 'marge',
        :course => 'vm333',
        :date => Date.new(2001, 2, 4),
        :time => MORNING,
        :groups => [ {:procedures => ['floating'],
                       :animals => ['twitter', 'jinx']},
                     {:procedures => ['venipuncture'],
                       :animals => ['jinx']}]
      }
      @reservation = Reservation.create_with_groups(test_data)
    end

    context "has results that have nothing to do with exclusions" do
      setup do 
        get "/json/reservation/#{@reservation.pk}?ignoring=#{@reservation.pk}"
        assert_json_response
        @result = JSON[last_response.body]
      end

      should "retrieve atomic values" do
        assert { 'marge' == @result['instructor'] }
        assert { 'vm333' == @result['course'] }
        assert { '2001-02-04' == @result['date'] }
        assert { MORNING == @result['time'] }
      end

      should "retrieve groups" do
        expected = [ {'procedures' => ['floating'],
                       'animals' => ['jinx', 'twitter']},
                     {'procedures' => ['venipuncture'],
                       'animals' => ['jinx']}
                   ];
        assert { expected == @result['groups'] }
      end

      should "retrieve procedure information" do
        assert { ['floating', 'venipuncture'] == @result['procedures'].sort }
      end

      should "return the reservation id as a string" do # { footnote 'string' }
        assert { @reservation.pk.to_s == @result['id'] }
      end
    end


    context "and ignoring exclusions associated with it" do

      setup do 
        get "/json/reservation/#{@reservation.pk}?ignoring=#{@reservation.pk}"
        assert_json_response
        @result = JSON[last_response.body]
      end

      should "retrieve exclusion information that does not include animals used in the reservation" do
        expected = { 'floating' => [], 'venipuncture' => [] }
        assert { expected == @result['exclusions'] }
      end

      should "retrieve animal information" do
        expected_animals = ['twitter', 'jinx']
        expected_kind_map = {'twitter' => 'sugar glider', 'jinx' => 'red-eared slider'}
        assert { expected_animals.sort == @result['animals'].sort }
        assert { expected_kind_map == @result['kindMap'] }
      end
      
    end

    context "but not using reservation to ignore exclusions" do

      setup do 
        get "/json/reservation/#{@reservation.pk}?ignoring="
        assert_json_response
        @result = JSON[last_response.body]
      end

      should "retrieve exclusion information that does include animals used in the reservation" do
        expected = {
          'floating' => ['jinx', 'twitter'],
          'venipuncture' => ['jinx', 'twitter'] # twitter excluded because it's same day.
        }
        assert { expected == @result['exclusions'] }
      end

      should "retrieve no animals because all are in use" do
        assert { [] == @result['animals'] } 
      end
    end
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

