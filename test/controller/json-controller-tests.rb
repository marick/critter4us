$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller'

class JsonGenerationTests < Test::Unit::TestCase
  include Rack::Test::Methods

  attr_reader :app

  def setup
    empty_tables
    @app = Controller.new
    @app.authorizer = AuthorizeEverything.new
  end

  def assert_json_response
    assert { last_response['Content-Type'] == 'application/json' }
  end

  def assert_jsonification_of(ruby_obj)
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
         'animals' => ['animal', 'date mismatch animal', 'time mismatch animal'],
         'kindMap' => {'time mismatch animal' => 'time mismatch kind',
                       'date mismatch animal' => 'date mismatch kind',
                       'animal' => 'animal kind'},

        'exclusions' => { 'date mismatch procedure' => ['animal'],
                          'time mismatch procedure' => ['animal','time mismatch animal'],
                          'procedure' => ['animal'] }
         })
    end

  end

  context "delivering all animals" do
    should "return a JSON list of names, together with name-to-kind hash" do
      Animal.random(:name => 'bossie', :kind => 'bovine');
      get '/json/all_animals'
      assert_json_response
      assert_jsonification_of({'animals' => [ ['bossie'], {'bossie' => 'bovine'}]})
    end

    should "also sort the list" do
      Animal.random(:name => 'wilbur', :kind => 'horse')
      Animal.random(:name => 'bossie', :kind => 'bovine')
      Animal.random(:name => 'hank', :kind => 'horse')
      Animal.random(:name => 'betsy', :kind => 'bovine')
      get '/json/all_animals'
      assert_jsonification_of({'animals' => [
              ['betsy', 'bossie', 'hank', 'wilbur'],
              {'betsy' => 'bovine', 'bossie' => 'bovine','hank' => 'horse', 'wilbur' => 'horse'}]})
    end
  end

  context "delivering exclusions" do

    should "hand over the exclusion hash" do
      
      DB.populate do
        Reservation.random(:date => '2009-07-03') do
          use Animal.random
          use Procedure.random(:days_delay => 14.days)
        end
      end

      get '/json/exclusions', {:date => '2009-07-13', :time => "morning"}
      assert_json_response
      expected_exclusion = {Procedure.first.name => [Animal.first.name]}
      assert_jsonification_of({'exclusions' => expected_exclusion})
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

    should "return the reservation number" do
      post '/json/store_reservation', :data => @data.to_json
      assert_json_response
      r = Reservation[:date => Date.new(2009, 02, 03)]
      assert_jsonification_of({'reservation' => r.id.to_s})
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
      get "/json/reservation/#{@reservation.id}"
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

    should "return the reservation id" do
      assert { @reservation.pk == @result['id'] }
    end

  end
  
end
