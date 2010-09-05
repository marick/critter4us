class TestViewClass
  attr_reader :variables

  def [](key)
    @variables[key]
  end

  def new(variables = {})
    @variables = variables
    "ensure that the return value is a string"
  end
end
