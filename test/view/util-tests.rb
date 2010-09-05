$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ViewHelperTests < Test::Unit::TestCase
  include ViewHelper

  should "convert elements into counted elements" do
    assert_equal(["1 time", "2 times (2 times)"],
                 count_annotated(["2 times", "1 time", "2 times"]))
  end

  should "be able to strip parenthetical remarks" do
    assert_equal(["leg wrapping"],
                 without_parens(["leg wrapping (horses)"]))
  end

  should "be able to highlight words" do
    assert_equal(["<b>leg</b> wrapping", "<b>fake</b>"],
                 highlighted_first_words(["leg wrapping", "fake"]))
  end

  context "timeslice summaries" do 
    should "work for singleton times" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,10),
                                TimeSet.new(MORNING))
      assert_equal("on the morning of 2009-12-10", timeslice.pretty)
    end

    should "work for two times" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,10),
                                TimeSet.new(EVENING, AFTERNOON))

      assert_equal("on the afternoon and evening of 2009-12-10",
                   timeslice.pretty)
    end

    should "work for three times" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,10),
                                TimeSet.new(MORNING, EVENING, AFTERNOON))
      assert_equal("for the whole day on 2009-12-10", timeslice.pretty)
    end

    should "work for singleton times on a range of dates" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,11),
                                TimeSet.new(MORNING))
      assert_equal("on the mornings of 2009-12-10 through 2009-12-11", timeslice.pretty)
    end

    should "work for multiple times on a range of dates" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,11),
                                TimeSet.new(EVENING, AFTERNOON))
      assert_equal("on the afternoons and evenings of 2009-12-10 through 2009-12-11", timeslice.pretty)
    end

    should "work for all times on a range of dates" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,11),
                                TimeSet.new(EVENING, AFTERNOON, MORNING))
      assert_equal("for the whole day on 2009-12-10 through 2009-12-11", timeslice.pretty)
    end
  end
end


