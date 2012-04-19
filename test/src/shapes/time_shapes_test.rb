require './test/testutil/fast-loading-requires'
require './src/shapes/requires'

class TimeShapedTests < Test::Unit::TestCase
  include Stunted
  include Stunted::Stutils

  context "in_descending_sort_order" do
    should "sort with newest first" do 
      input = Fall([{expected_position: "second", first_date: Date.new(2001)},
                    {expected_position: "first",  first_date: Date.new(2012)}],
                   array: TimeslicedElementShaped)
      actual = input.in_descending_date_order
      assert {actual[0].expected_position == "first"}
      assert {actual[1].expected_position == "second"}
    end

    should "put mornings first within a day" do
      m = ->where, bits { 
        {expected_position: where, time_bits: bits, first_date: Date.new(2001)}        }

      input = Fall([
                    m.(7, "001"),
                    m.(6, "011"),
                    m.(3, "111"),
                    m.(5, "010"),
                    m.(4, "101"),
                    m.(2, "110"),
                    m.(1, "100"),
                   ],
                   array: TimeslicedElementShaped)
      expected = input.map(&:expected_position).sort
      actual = input.in_descending_date_order.map(&:expected_position)
      assert {actual == expected }
    end

    should "produce the same class of object" do
      input = Fall([{first_date: Date.new(2001)},
                    {first_date: Date.new(2012)}],
                   array: TimeslicedElementShaped)
      assert { input.in_descending_date_order.class == input.class } 
    end
  end
end
