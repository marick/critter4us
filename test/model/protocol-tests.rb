$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ProtocolTests < FreshDatabaseTestCase

  context "class" do
    setup do
      @floating = Procedure.random(:name => 'floating')
      @protocol = Protocol.random(:procedure => @floating)
    end

    should "be able to return appropriate instance" do
      assert { @protocol = Protocol.for(:procedure => @floating) }
    end
  end
end
