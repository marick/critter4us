require 'test/testutil/db-helpers'

class FreshDatabaseTestCase < Test::Unit::TestCase
  include DBHelpers
  def default_test; 'silence test::unit whining about missing tests'; end

  def setup
    empty_tables
  end
end
