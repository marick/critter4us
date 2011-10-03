$: << '../..' unless $in_rake
require './test/testutil/requires'
require './util/requires'

class ReshaperTests < Test::Unit::TestCase
  def setup
    @reshaper = Reshaper.new
  end

  context "turning tuples into sorted, uniquified arrays" do
    should "allow reshaping single-element tuples (so key is not needed)" do
      assert_equal(["A", "b", "C", "d"],
                   @reshaper.tuples_to_presentable_array([{:x => "b"},
                                                          {:x => "A"},
                                                          {:x => "C"},
                                                          {:x => "d"}]))
    end

    should "omit duplicates" do
      assert_equal(["A"],
                   @reshaper.tuples_to_presentable_array([{:x => "A"}, {:x => "A"}]))
    end

    should "be able to make array of values from a key" do 
      assert_equal(["A", "b", "C", "d"],
                   @reshaper.tuples_to_presentable_array([{:x => "C", :y => 1},
                                                          {:x => "A", :y => 2},
                                                          {:x => "b", :y => 3},
                                                          {:x => "d", :y => 4}],
                                                         :x))
    end

    should "stamp array as presentable" do 
      result = @reshaper.tuples_to_presentable_array([{:x => "1"}])
      assert { result.legacy.presentable }
    end

  end

  should "convert tuple-pairs to hashes" do 
    assert_equal({'one' => 1, 'two' => 2},
                 @reshaper.pairs_to_hash([{:word => 'one', :value => 1},
                                          {:word => 'two', :value => 2}],
                                         :word, :value))
  end

  context "grouping tuples by keys" do 
    should "group value by keys" do 
      assert_equal({'one' => [1, 11], 'two' => [2]},
                   @reshaper.group_by([{:word => 'one', :value => 1},
                                       {:word => 'one', :value => 11},
                                       {:word => 'two', :value => 2}],
                                      :word, :value))
    end
    should "create empty-list values" do 
      assert_equal({'one' => [], 'two' => []},
                   @reshaper.empty_key_groups([{:word => 'one'},
                                               {:word => 'two'},
                                               {:word => 'two'}], :word))
    end
  end

end
