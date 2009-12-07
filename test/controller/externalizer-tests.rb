$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller/externalizer'

class ExternalizerTests < Test::Unit::TestCase
  def setup
    @externalizer = Externalizer.new
  end

  should "convert symbol keys into strings" do
    input = {:key => 'value'}
    expected = {'key' => 'value'}.to_json

    actual = @externalizer.convert(input)
    assert_equal(expected, actual)
  end

  should "convert animals into names" do
    input = {:key => [Animal.new(:name => 'fred')]}
    expected = {'key' => ['fred']}.to_json

    actual = @externalizer.convert(input)
    assert_equal(expected, actual)
  end
  
  should "convert procedures into names" do
    input = {:key => [Procedure.new(:name => 'levitation')]}
    expected = {'key' => ['levitation']}.to_json

    actual = @externalizer.convert(input)
    assert_equal(expected, actual)
  end

  should "convert dates into strings" do
    input = {:key => Date.new(2009, 10, 1)}
    expected = {'key' => "2009-10-01"}.to_json

    actual = @externalizer.convert(input)
    assert_equal(expected, actual)
  end

  should "recursively convert hashes" do 
    input = {:exclusions => { 
        Procedure.new(:name => 'levitation') => [Animal.new(:name => 'fred')]
      }
    }
            
    expected = {'exclusions' => {
        'levitation' => ['fred']
      }
    }.to_json

    actual = @externalizer.convert(input)
    assert_equal(expected, actual)
  end    
  
end
