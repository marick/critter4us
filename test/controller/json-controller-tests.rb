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

  should "convert to consistent internal format" do
    input = {
      "stringkey" => "value",
      "time" => "morning",
      "date" => "2009-12-01",
      "animals" => ["an", "array"],
    };
    actual = app.move_to_internal_format(input)
    expected = {
      :stringkey => 'value', :morning => true,
      :date => Date.new(2009,12,1),
      :animals => ["an", "array"]
    }
    assert { actual == expected }
  end

  context "delivering procedure names" do

    should "return a JSON list of strings" do
      Procedure.random(:name => 'a')
      get '/json/procedures'
      assert_json_response
      assert_jsonification_of({'procedures' => ['a']})
    end

    should "also sort the list" do
      Procedure.random_with_names('c', 'a', 'b')
      get '/json/procedures'
      assert_jsonification_of({'procedures' => ['a', 'b', 'c']})
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

    context "zero-delay animals" do 

      setup do
        @date_of_interest = "2009-12-01"
        @next_day = '2009-12-02'
        DB.populate do
          Reservation.random(:date => @date_of_interest,
                             :morning => true) do
            use Animal.random(:name => 'morning animal')
            use Procedure.random(:days_delay => 0.days, 
                                 :name => 'first procedure')
          end
          
          Reservation.random(:date => @date_of_interest,
                             :morning => false) do
            use Animal.random(:name => "afternoon animal")
            use Procedure.random(:days_delay => 0.days,
                                 :name => "second procedure")
          end
        end
      end

      should "be excluded from being reserved twice in a morning" do
        get '/json/exclusions',
            {:date => @date_of_interest, :time => "morning"}
        expected = {
          'first procedure' => ['morning animal'],
          'second procedure' => ['morning animal']
        }    
        assert_jsonification_of({'exclusions' => expected})
      end


      should "be excluded from being reserved twice in an afternoon" do
        get '/json/exclusions',
            {:date => @date_of_interest, :time => "afternoon"}
        expected = {
          'first procedure' => ['afternoon animal'],
          'second procedure' => ['afternoon animal']
        }
        assert_jsonification_of({'exclusions' => expected})
      end

      should "be unaffected when attempt is on different days" do
        get '/json/exclusions',
            {:date => @next_day, :time => 'morning'}
        expected = { 
          'first procedure' => [],
          'second procedure' => []
        }
        assert_jsonification_of({'exclusions' => expected})
      end
      
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
        'procedures' => ['lick', 'slop'],
        'animals' => ['twitter', 'jinx']}
    end

    should "create the required uses" do
      post '/json/store_reservation', :data => @data.to_json
      r = Reservation[:date => Date.new(2009, 02, 03)]
      assert { r.morning }
      assert { r.instructor == @data['instructor'] }
      assert { r.course == @data['course'] }
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
end
