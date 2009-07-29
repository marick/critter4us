require 'test/testutil/requires'

require 'controller'
require 'persistent-store'

class JsonGenerationTests < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @store = flexmock('persistent store')
  end

  def app
    Controller.new(:persistent_store => @store)
  end

  def assert_json_response
    assert { last_response['Content-Type'] == 'application/json' }
  end

  def assert_jsonification_of(ruby_obj)
    assert { ruby_obj == JSON[last_response.body] }
  end


  context "delivering procedure names" do

    should "use a method on the persistent store" do
      assert { PersistentStore.instance_methods.include? 'procedure_names' }
    end

    should "return a JSON list of strings" do
      during { 
        get '/json/procedures'
      }.behold! {
        @store.should_receive(:procedure_names).and_return(['a'])
      }
      assert_json_response
      assert_jsonification_of({'procedures' => ['a']})
    end


    should "also sort the list" do
      during { 
        get '/json/procedures'
      }.behold! {
        @store.should_receive(:procedure_names).and_return(['c', 'a', 'b'])
      }
      assert_jsonification_of({'procedures' => ['a', 'b', 'c']})
    end
  end

  context "delivering all animals" do
    should "use a method on the persistent store" do
      assert { PersistentStore.instance_methods.include? 'all_animals' }
    end

    should "return a JSON list of strings" do
      during { 
        get '/json/all_animals'
      }.behold! {
        @store.should_receive(:all_animals).and_return(['bossie'])
      }
      assert_json_response
      assert_jsonification_of({'animals' => ['bossie']})
    end


    should "also sort the list" do
      during { 
        get '/json/all_animals'
      }.behold! {
        @store.should_receive(:all_animals).and_return(['bossie', 'betsy'])
      }
      assert_jsonification_of({'animals' => ['betsy', 'bossie']})
    end
  end

  context "delivering exclusions" do
    should "use a method on the persistent store" do
      assert { PersistentStore.instance_methods.include? 'exclusions_for_date' }
    end

    should "deliver a date object to the persistent store" do
      sample_exclusion = {'procedure name' => ['excluded animal']}
      during {
        get '/json/exclusions', {:date => '2009-07-23'}
      }.behold! {
        @store.should_receive(:exclusions_for_date).
               with(Date.new(2009, 7, 23)).
               and_return(sample_exclusion)
      }

      assert_json_response
      assert_jsonification_of({'exclusions' => sample_exclusion})
    end

  end


end
