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

class NullProtocolTests < FreshDatabaseTestCase


  def setup
    @floating = Procedure.random(:name => 'floating')
    super
  end

  context "a legitimate animal kind" do 
    setup do
      @null_protocol = Protocol::Null.new(@floating, 'bovine')
    end

    should "have an id that's distinct yet stable from instance to instance" do
      assert { @null_protocol.unique_identifier == "no_protocol_defined_for_#{@floating.pk}_and_bovine" }
    end


    should "return a description" do
      expected = /floating/
      assert { /floating/ =~ @null_protocol.description }
      assert { /bovine/ =~ @null_protocol.description }
      assert { /[Nn]o protocol.*defined/ =~ @null_protocol.description }
    end
  end

  context "no animal kind" do 
    setup do
      @null_protocol = Protocol::Null.new(@floating, nil)
    end

    should "be suitably vague when asked the animal kind" do 
      assert { @null_protocol.animal_kind == 'any species' } 
    end

    should "have an id that's distinct yet stable from instance to instance" do
      assert { @null_protocol.unique_identifier == "no_protocol_defined_for_#{@floating.pk}_and_any_species" }
    end

    should "return a description" do
      expected = /floating/
      assert { /floating/ =~ @null_protocol.description }
      assert { /any species/ =~ @null_protocol.description }
      assert { /[Nn]o protocol.*defined/ =~ @null_protocol.description }
    end
  end

end
