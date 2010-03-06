$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'util/requires'

class ReshaperTests < Test::Unit::TestCase
  def setup
    @reshaper = Reshaper.new
  end

  should "be able to reshape single-element tuples into sorted arrays" do
    assert_equal(["A", "b", "C", "d"],
                 @reshaper.singleton_tuple_to_sorted_array([{:x => "b"},
                                                            {:x => "A"},
                                                            {:x => "C"},
                                                            {:x => "d"}]))
                                                            
  end

  should "omit duplicates (single-element)" do
    assert_equal(["A"],
                 @reshaper.singleton_tuple_to_sorted_array([{:x => "A"}, {:x => "A"}]))
  end

  should "be able to make array of values from particular key" do 
    assert_equal(["A", "b", "C", "d"],
                 @reshaper.one_value_sorted_array([{:x => "C", :y => 1},
                                                   {:x => "A", :y => 2},
                                                   {:x => "b", :y => 3},
                                                   {:x => "d", :y => 4}],
                                                  :x))
  end

  should "omit duplicates (selection)" do
    assert_equal(["A"],
                 @reshaper.one_value_sorted_array([{:x => "A", :y => 1},
                                                   {:x => "A", :zzz => 1}],
                                                  :x))
  end


  should "convert tuple-pairs to hashes" do 
    assert_equal({'one' => 1, 'two' => 2},
                 @reshaper.pairs_to_hash([{:word => 'one', :value => 1},
                                          {:word => 'two', :value => 2}],
                                         :word, :value))
  end

end
