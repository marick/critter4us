class TestViewClass
  attr_reader :variables

  def [](key)
    @variables[key]
  end

  def new(variables = {})
    @variables = variables
  end
end
