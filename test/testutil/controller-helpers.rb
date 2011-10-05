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
