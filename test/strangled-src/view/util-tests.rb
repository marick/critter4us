require './test/testutil/requires'
require './strangled-src/model/requires'
require './strangled-src/view/requires'

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

end


