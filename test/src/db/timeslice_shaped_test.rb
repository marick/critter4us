require './test/testutil/requires'
require 'stunted'
require './src/db/shapes'

class TimesliceShapedTests < Test::Unit::TestCase
  include Stunted
  include Stunted::FHUtil

  def shape(content)
    @subject = F(content).become(TimesliceShaped)
  end

  context "date text" do
    should "have one date for same first and last date" do
      one_date = Date.new(2008, 5, 4)
      shape(:first_date => one_date, :last_date => one_date)
      assert { @subject.date_text == "2008-05-04" }
    end

    should "produce a date range" do
      shape(:first_date => Date.new(2008, 5, 4),
            :last_date =>  Date.new(2009, 6, 11))
      assert { @subject.date_text == "2008-05-04 to 2009-06-11" }
    end
  end

  should "print useful time-of-day information" do
    assert { shape(:time_bits => "100").time_of_day == "morning" } 
    assert { shape(:time_bits => "010").time_of_day == "afternoon" } 
    assert { shape(:time_bits => "001").time_of_day == "evening" } 
    assert { shape(:time_bits => "101").time_of_day == "morning, evening" } 
  end
  
end
