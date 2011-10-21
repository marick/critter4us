require 'ostruct'

class TestViewClass
  attr_reader :variables

  def [](key)
    @variables[key]
  end

  def new(variables = {})
    @variables = variables
    OpenStruct.new(:to_html => "ensure that the return value gives a string when htmlified")
  end
end

module JsonHelpers
  def assert_json_response
    assert { last_response['Content-Type'] == 'application/json' }
  end

  def assert_jsonification_of(ruby_obj)
    # pp JSON[last_response.body]
    assert_equal(ruby_obj, JSON[last_response.body])
  end
end
