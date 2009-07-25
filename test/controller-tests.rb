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
end
