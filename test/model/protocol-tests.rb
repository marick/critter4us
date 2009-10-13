$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ProtocolTests < FreshDatabaseTestCase

  context "class" do
    setup do
      @floating = Procedure.random(:name => 'floating')
    end

    should "be able to return appropriate description when no specialization" do
      protocol = Protocol.random(:procedure => @floating, :animal_kind => 'all')
      expected = { 'all' => protocol }
      actual = Protocol.protocols_for(@floating)
      assert { actual == expected }
    end


    should "be able to return appropriate descriptions when per-animal specialization" do
      bovine = Protocol.random(:procedure => @floating, :animal_kind => 'bovine',
                               :description => 'bovine floating')
      caprine = Protocol.random(:procedure => @floating, :animal_kind => 'caprine',
                                :description => 'caprine floating')
      expected = { 'caprine' => caprine, 'bovine' => bovine }
      actual = Protocol.protocols_for(@floating)
      assert { actual == expected }
    end
  end
end
