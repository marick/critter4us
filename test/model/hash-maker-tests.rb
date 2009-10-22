$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class HashMakerTests < Test::Unit::TestCase
  def setup
    @maker = HashMaker.new
    @a = flexmock('animal a', :name => 'a')
    @f = flexmock('animal f', :name => 'f')
    @m = flexmock('animal m', :name => 'm')
    @z = flexmock('animal z', :name => 'z')
    @p_ = flexmock('p_', :name => 'p_')
    @p_p_ = flexmock('p_p_', :name => 'p_p_')
    @p_p_ = flexmock('p_p_', :name => 'p_p_')
    @p_p_p_ = flexmock('p_p_p_', :name => 'p_p_p_')
  end

  context "keys and pairs conversion" do
    should "produce empty values when no pairs" do 
      actual = @maker.keys_and_pairs(['p_'], [])
      expected = { 'p_' => [] }
      assert { actual == expected } 
    end

    should "produce sorted list as values" do 
      actual = @maker.keys_and_pairs(['p_'], 
                                     [[@p_, @z], [@p_, @f],
                                      [@p_, @m], [@p_, @a]])
      expected = { 'p_' => ['a', 'f', 'm', 'z'] }
      assert { actual == expected } 
    end

    should "strip duplicates for a single key" do 
      actual = @maker.keys_and_pairs(['p_'], 
                                     [[@p_, @z], [@p_, @z],
                                      [@p_, @m], [@p_, @z]])
      expected = { 'p_' => ['m', 'z'] }
      assert { actual == expected } 
    end

    should "handle multiple keys" do 
      actual = @maker.keys_and_pairs(['p_', 'p_p_', 'p_p_p_'], 
                                     [[@p_, @z], [@p_, @z],
                                      [@p_p_, @m], [@p_p_ , @z]])
      expected = { 'p_' => ['z'],
                   'p_p_' => ['m', 'z'],
                   'p_p_p_' => [] }
      assert { actual == expected } 
    end

  end

end
