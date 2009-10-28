$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller'

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
    assert { ruby_obj == JSON[last_response.body] }
  end

  context "utilities" do
    should "turn hash keys into symbols" do
      input = { 'key' => 'value' } 
      expected = { :key => 'value' }
      assert { expected == app.symbol_keys(input) }
    end

    should "convert to consistent internal format" do
      input = {
        "stringkey" => "value",
        "time" => "morning",
        "date" => "2009-12-01",
        "groups" => [ {'animals' => ['josie', 'frank'],
                        'procedures' => ['venipuncture']}],
      };
      actual = app.move_to_internal_format(input)
      expected = {
        :stringkey => 'value', :morning => true,
        :date => Date.new(2009,12,1),
        :groups => [{:animals => ['josie', 'frank'],
                      :procedures => ['venipuncture']}]
      }
      assert { actual == expected }
    end
  end

  context "delivering a blob of course-session-specific data" do

    should "exclude animals that are currently in use" do 
      @app.override(mocks(:timeslice, :animal_source, :procedure_source,
                          :procedure_rules, :hash_maker))
      pairs = []
      during { 
        get '/json/course_session_data_blob', {:date => '2009-01-01', :time => "morning"}
      }.behold! {
        @timeslice.should_receive(:move_to).once.with(Date.new(2009,1, 1), true)
        @timeslice.should_receive(:available_animals_by_name).once.and_return('some animals')
        @procedure_source.should_receive(:sorted_names).once.and_return('some procedure names')

        @timeslice.should_receive(:add_excluded_pairs).once.with(pairs)
        @hash_maker.should_receive(:keys_and_pairs).once.
                    with('some procedure names', pairs).
                    and_return('some exclusions')

        @animal_source.should_receive(:kind_map).once.and_return('some kind map')
      }
      assert_json_response
      assert_jsonification_of({
         'animals' => 'some animals',
         'procedures' => 'some procedure names',
         'kindMap' => 'some kind map',
         'exclusions' => 'some exclusions'})
    end

    # The following test predates mocks. They can continue to be used
    # but they're probably not worth fixing if they break.

    should "return a JSON list of strings" do
      Reservation.random(:date => Date.new(2009, 3, 3), :morning => true) do 
        use Procedure.random(:name => 'date mismatch procedure', :days_delay => 0)
        use Animal.random(:name => 'date mismatch animal', :kind => 'date mismatch kind')
      end
      
      Reservation.random(:date => Date.new(2009, 1, 1), :morning => false) do 
        use Procedure.random(:name => 'time mismatch procedure', :days_delay => 1)
        use Animal.random(:name => 'time mismatch animal', :kind => 'time mismatch kind')
      end

      Reservation.random(:date => Date.new(2009, 1, 1), :morning => true) do
        use Procedure.random(:name => 'procedure', :days_delay => 3)
        use Animal.random(:name => 'animal', :kind => 'animal kind')
      end

      get '/json/course_session_data_blob', {:date => '2009-01-01', :time => "morning"}
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

  context "adding a reservation" do 

    setup do
      Animal.random_with_names('twitter', 'jinx')
      Procedure.random_with_names('lick', 'slop')

      @data = {
        'date' => '2009-02-03',
        'time' => 'morning',
        'instructor' => 'morin',
        'course' => 'vm333',
        'groups' => [ {'procedures' => ['lick', 'slop'],
                        'animals' => ['twitter', 'jinx']} ]
      }
    end

    should "create the required uses" do
      post '/json/store_reservation', :data => @data.to_json
      r = Reservation[:date => Date.new(2009, 02, 03)]
      assert { r.morning }
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
        :morning => true,
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
      assert { @id_to_modify == @new_reservation.pk.to_s }
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
        :morning => true,
        :groups => [ {:procedures => ['floating'],
                       :animals => ['twitter', 'jinx']},
                     {:procedures => ['venipuncture'],
                       :animals => ['jinx']}]
      }
      @reservation = Reservation.create_with_groups(test_data)
      get "/json/reservation/#{@reservation.pk}"
      assert_json_response
      @result = JSON[last_response.body]
    end

    should "retrieve atomic values" do
      assert { 'marge' == @result['instructor'] }
      assert { 'vm333' == @result['course'] }
      assert { '2001-02-04' == @result['date'] }
      assert { true == @result['morning'] }
    end

    should "retrieve groups" do
      expected = [ {'procedures' => ['floating'],
                     'animals' => ['jinx', 'twitter']},
                   {'procedures' => ['venipuncture'],
                     'animals' => ['jinx']}
                 ];
      assert { expected == @result['groups'] }
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
    
    should "retrieve procedure information" do
      assert { ['floating', 'venipuncture'] == @result['procedures'].sort }
    end

    should "return the reservation id as a string" do # { footnote 'string' }
      assert { @reservation.pk.to_s == @result['id'] }
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

