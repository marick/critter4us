$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller/internalizer'

class InternalizerTests < Test::Unit::TestCase
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

  should "interpret a 'data' key as pointing to json data to translate" do
    input = { 
      'top_level' => "top level",
      'data' => { 
        :date => '2009-12-12',
        :second => 'second'
      }.to_json
    }

    actual = Internalizer.new.convert(input)

    expected = {
      :top_level => "top level",
      :data => {
        :date => Date.new(2009, 12, 12),
        :second => 'second'
      }
    }

    assert_equal(expected, actual)
  end
end