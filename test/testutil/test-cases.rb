class FreshDatabaseTestCase < Test::Unit::TestCase
  def default_test; 'silence test::unit whining about missing tests'; end

  def setup
    empty_tables
  end
end
