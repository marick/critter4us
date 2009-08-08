require 'test/testutil/requires'
require 'test/testutil/dbhelpers'

require 'controller'
require 'admin/tables'

class JsonGenerationTests < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    empty_tables
  end

  def app
    Controller.new
  end

  def assert_json_response
    assert { last_response['Content-Type'] == 'application/json' }
  end

  def assert_jsonification_of(ruby_obj)
    assert { ruby_obj == JSON[last_response.body] }
  end

  context "delivering procedure names" do

    should "return a JSON list of strings" do
      create(Procedure, 'a')
      get '/json/procedures'
      assert_json_response
      assert_jsonification_of({'procedures' => ['a']})
    end

    should "also sort the list" do
      create(Procedure, 'c', 'a', 'b')
      get '/json/procedures'
      assert_jsonification_of({'procedures' => ['a', 'b', 'c']})
    end
  end

  context "delivering all animals" do
    should "return a JSON list of strings" do
      create(Animal, 'bossie');
      get '/json/all_animals'
      assert_json_response
      assert_jsonification_of({'animals' => ['bossie']})
    end


    should "also sort the list" do
      create(Animal, 'wilbur', 'bossie', 'hank', 'betsy');
      get '/json/all_animals'
      assert_jsonification_of({'animals' => ['betsy', 'bossie', 'hank', 'wilbur']})
    end
  end

  context "delivering exclusions" do

    should "hand over the exclusion hash" do
      Reservation.create_with_uses(Date.new(2009, 7, 20),
                                   ['procedure name'],
                                   ['excluded animal'],
                                   :find_or_create)
      Procedure.first.update(:days_delay => 14)

      get '/json/exclusions', {:date => '2009-07-23'}
      assert_json_response
      expected_exclusion = {'procedure name' => ['excluded animal']}
      assert_jsonification_of({'exclusions' => expected_exclusion})
    end

  end

  context "adding a reservation" do 

    setup do 
      create(Animal, 'hum', 'bug')
      create(Procedure, 'sloop', 'slop')

      @data = {'date' => '2009-02-03',
 	      'procedures' => ['sloop', 'slop'],
	      'animals' => ['hum', 'bug']}
    end

    should "create the required uses" do
      post '/json/store_reservation', :data => @data.to_json
      r = Reservation[:date => Date.new(2009, 02, 03)]
      assert { r.uses.size == 4 }
      assert do 
        r.uses.find do | u | 
          u.animal.name == 'hum' && u.procedure.name == 'slop'
        end
      end
    end

    should "return the reservation number" do
      post '/json/store_reservation', :data => @data.to_json
      assert_json_response
      r = Reservation[:date => Date.new(2009, 02, 03)]
      assert_jsonification_of({'reservation' => r.id})
    end
  end
end
