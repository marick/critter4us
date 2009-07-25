require 'test/unit'
require 'flexmock/test_unit'

# This file contains methods I find useful when using mocks.

# These methods are used to change the flow of control so that the
# test can state what is to happen before stating what the mock should
# receive.
class Test::Unit::TestCase
  def because(&block)
    @because = block
    self
  end
  alias_method :during, :because
  alias_method :whenever, :because

  def behold!
    yield
    @result = @because.call
  end

  # Shouldn't use this with partial mocks, since it doesn't
  # trap the underlying class's methods. You don't know that
  # *nothing* happens, only that default mocks weren't called.
  def behold_nothing_happens!
    behold! {}
  end
end
