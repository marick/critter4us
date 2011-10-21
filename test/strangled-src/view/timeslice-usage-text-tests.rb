$: << '../..' unless $in_rake
require './test/testutil/requires'
require './strangled-src/model/requires'
require './strangled-src/view/requires'

class TimesliceUsageTextTests < Test::Unit::TestCase
  include ViewHelper

  context "timeslice summaries" do 
    should "work for singleton times" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,10),
                                TimeSet.new(MORNING))
      text = TimesliceUsageText.new(:timeslice => timeslice).to_html
      assert_equal("Animals in use on the morning of 2009-12-10", text)
    end

    should "work for two times" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,10),
                                TimeSet.new(EVENING, AFTERNOON))
      text = TimesliceUsageText.new(:timeslice => timeslice).to_html

      assert_equal("Animals in use during the afternoon or evening of 2009-12-10",
                   text)
    end

    should "work for three times" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,10),
                                TimeSet.new(MORNING, EVENING, AFTERNOON))
      text = TimesliceUsageText.new(:timeslice => timeslice).to_html
      assert_equal("Animals in use at any time during 2009-12-10", text)
    end

    should "work for singleton times on a range of dates" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,11),
                                TimeSet.new(MORNING))
      text = TimesliceUsageText.new(:timeslice => timeslice).to_html
      assert_equal("Animals in use on the mornings of 2009-12-10 through 2009-12-11", text)
    end

    should "work for multiple times on a range of dates" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,11),
                                TimeSet.new(EVENING, AFTERNOON))
      text = TimesliceUsageText.new(:timeslice => timeslice).to_html
      assert_equal("Animals in use during the afternoons or evenings of 2009-12-10 through 2009-12-11", text)
    end

    should "work for all times on a range of dates" do 
      timeslice = Timeslice.new(Date.new(2009,12,10),
                                Date.new(2009,12,11),
                                TimeSet.new(EVENING, AFTERNOON, MORNING))
      text = TimesliceUsageText.new(:timeslice => timeslice).to_html
      assert_equal("Animals in use at any time during 2009-12-10 through 2009-12-11", text)
    end
  end

end
