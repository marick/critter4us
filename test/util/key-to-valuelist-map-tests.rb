$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'util/requires'

class KeyToValuelistMapTests < Test::Unit::TestCase

  should "initialize with empty value lists" do 
    assert_equal( { "a" => [], "b" => [] },
                  KeyToValuelistMap.new(['a', 'b']))
  end


  should "reshape tuples into [{'first' => ['second'...]}]" do 
    map = KeyToValuelistMap.new(["p1", "p2", "p3"])
    tuples = [ { :procedure_name => 'p1', :animal_name => "Z"},
               { :procedure_name => 'p2', :animal_name => "Z"},
               { :procedure_name => 'p1', :animal_name => "D"},
               { :procedure_name => 'p1', :animal_name => "b"},
               { :procedure_name => 'p1', :animal_name => "M"},
               { :procedure_name => 'p1', :animal_name => "M"},
               { :procedure_name => 'p1', :animal_name => "M"},
               { :procedure_name => 'p2', :animal_name => "M"},
               { :procedure_name => 'p1', :animal_name => "f"} ]
    assert_equal({'p1' => ['b', 'D', 'f', 'M', 'Z'],
                  'p2' => ['M', 'Z'],
                  'p3' => [] },
                 map.add_specific_pairs(tuples,
                                        :procedure_name,
                                        :animal_name))
  end

  should "spread values across keys" do 
    map = KeyToValuelistMap.new(%w{a b})
    map.spread_values_among_keys(%w{z z A f G})
    assert_equal( { 'a' => %w{A f G z}, 'b' => %w{A f G z} }, map)
  end

end
  

