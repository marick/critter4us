$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class HashMakerTests < Test::Unit::TestCase
  def setup
    @maker = HashMaker.new
  end

  context "keys and pairs conversion" do
    should "allow empty list for key" do 
      actual = @maker.keys_and_pairs(['procedure'], [])
      expected = { 'procedure' => [] }
      assert { actual == expected } 
    end

    should "allow produce sorted list for key" do 
      actual = @maker.keys_and_pairs(['procedure'], 
                                     [['procedure', 'z'], ['procedure', 'f'],
                                      ['procedure', 'm'], ['procedure' ,'a']])
      expected = { 'procedure' => ['a', 'f', 'm', 'z'] }
      assert { actual == expected } 
    end

    should "allow not allow duplicates for a single key" do 
      actual = @maker.keys_and_pairs(['procedure'], 
                                     [['procedure', 'z'], ['procedure', 'z'],
                                      ['procedure', 'm'], ['procedure' ,'z']])
      expected = { 'procedure' => ['m', 'z'] }
      assert { actual == expected } 
    end

    should "allow have multiple keys duplicates for a single key" do 
      actual = @maker.keys_and_pairs(['1', '2', '3'], 
                                     [['1', 'z'], ['1', 'z'],
                                      ['2', 'm'], ['2' ,'z']])
      expected = { '1' => ['z'],
                   '2' => ['m', 'z'],
                   '3' => [] }
      assert { actual == expected } 
    end

  end

end
