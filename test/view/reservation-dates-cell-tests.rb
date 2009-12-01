$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ReservationDatesCellWidgetTests < Test::Unit::TestCase
  include ViewHelper
  should "include dates in its output" do 
    html = ReservationDatesCell.new(:dates => [Date.new(2019, 12, 13),
                                               Date.new(2010, 1, 1)]).to_s
    assert { html.include? "2019-12-13" }
    assert { html.include? "2010-01-01" }
  end
end
