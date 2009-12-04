$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller/internalizer'

class InternalizationTests < Test::Unit::TestCase
  should "turn hash keys into symbols" do
    input = { 'key' => 'value' } 
    expected = { :key => 'value' }
    assert { expected == Internalizer.new.symbol_keys(input) }
  end

  should "convert to consistent internal format" do
    input = {
      "stringkey" => "value",
      "time" => MORNING,
      "date" => "2009-12-01",
      "groups" => [ {'animals' => ['josie', 'frank'],
                      'procedures' => ['venipuncture']}],
    }
    actual = Internalizer.new.convert(input)
    expected = {
      :stringkey => 'value', :time => MORNING,
      :date => Date.new(2009,12,1),
      :groups => [{:animals => ['josie', 'frank'],
                    :procedures => ['venipuncture']}]
    }
    assert { actual == expected }
  end
  
end
