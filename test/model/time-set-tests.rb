$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class TimeSetTests < Test::Unit::TestCase
  should "compare simple sets according to time of day" do
    assert_equal(0, TimeSet.new(MORNING) <=> TimeSet.new(MORNING))
    assert_equal(-1, TimeSet.new(MORNING) <=> TimeSet.new(AFTERNOON))
    assert_equal(-1, TimeSet.new(MORNING) <=> TimeSet.new(EVENING))

    assert_equal(1, TimeSet.new(AFTERNOON) <=> TimeSet.new(MORNING))
    assert_equal(0, TimeSet.new(AFTERNOON) <=> TimeSet.new(AFTERNOON))
    assert_equal(-1, TimeSet.new(AFTERNOON) <=> TimeSet.new(EVENING))

    assert_equal(1, TimeSet.new(EVENING) <=> TimeSet.new(MORNING))
    assert_equal(1, TimeSet.new(EVENING) <=> TimeSet.new(AFTERNOON))
    assert_equal(0, TimeSet.new(EVENING) <=> TimeSet.new(EVENING))
  end

  should "compare complex sets according to combined values" do
    assert_equal(-1, TimeSet.new(MORNING) <=> TimeSet.new(MORNING, AFTERNOON))
    assert_equal(-1, TimeSet.new(MORNING) <=> TimeSet.new(AFTERNOON, EVENING))
    assert_equal(-1, TimeSet.new(MORNING) <=> TimeSet.new(MORNING, EVENING))

    assert_equal(1, TimeSet.new(AFTERNOON) <=> TimeSet.new(MORNING, AFTERNOON))
    assert_equal(-1, TimeSet.new(AFTERNOON) <=> TimeSet.new(AFTERNOON, EVENING))
    assert_equal(1, TimeSet.new(AFTERNOON) <=> TimeSet.new(MORNING, EVENING))

    assert_equal(1, TimeSet.new(EVENING) <=> TimeSet.new(MORNING, EVENING))
    assert_equal(1, TimeSet.new(EVENING) <=> TimeSet.new(AFTERNOON, EVENING))

    assert_equal(-1, TimeSet.new(MORNING, AFTERNOON) <=> TimeSet.new(MORNING, EVENING))
    assert_equal(1, TimeSet.new(EVENING, AFTERNOON) <=> TimeSet.new(MORNING, EVENING))
    assert_equal(0, TimeSet.new(EVENING, AFTERNOON) <=> TimeSet.new(AFTERNOON, EVENING))

    assert_equal(-1, TimeSet.new(MORNING, AFTERNOON, EVENING) <=> TimeSet.new(AFTERNOON, EVENING))
    assert_equal(-1, TimeSet.new(MORNING, AFTERNOON, EVENING) <=> TimeSet.new(MORNING, EVENING))
    assert_equal(1, TimeSet.new(MORNING, AFTERNOON, EVENING) <=> TimeSet.new(MORNING))
    assert_equal(0, TimeSet.new(MORNING, AFTERNOON, EVENING) <=> TimeSet.new(MORNING, AFTERNOON, EVENING))

  end

end

