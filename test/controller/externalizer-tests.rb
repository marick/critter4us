$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'controller/externalizer'

class ExternalizerTests < FreshDatabaseTestCase
  def setup
    super
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

  should "convert sets into arrays" do
    input = {:times => Set.new([MORNING, EVENING]) }
    expected = {'times' => ['evening', 'morning']}.to_json

    actual = @externalizer.convert(input)
    assert_equal(expected, actual)
  end

  context "operates on group structures" do

    setup do 
      @fred = Animal.create(:name => 'fred')
      @betsy = Animal.create(:name => 'betsy')
      @floating = Procedure.create(:name => 'floating')
      @vaccination = Procedure.create(:name => 'vaccination')
      @group = Group.create
    end

    should "convert a one-use group into nested structures" do
      Use.create(:procedure => @floating, :animal => @fred, :group => @group)

      input = {:groups => [@group]}
      expected = {'groups' => [ {'procedures' => ['floating'],
                                  'animals' => ['fred']} ]}.to_json
      actual = @externalizer.convert(input)
      assert_equal(expected, actual)
    end

    should "not be fooled by duplication in uses" do
      Use.create(:procedure => @floating, :animal => @fred, :group => @group)
      Use.create(:procedure => @floating, :animal => @betsy, :group => @group)
      Use.create(:procedure => @vaccination, :animal => @fred, :group => @group)
      Use.create(:procedure => @vaccination, :animal => @betsy, :group => @group)

      input = {:groups => [@group]}
      expected = {'groups' => [{
                                 'procedures' => ['floating', 'vaccination'],
                                 'animals' => ['betsy', 'fred'] }]
                 }.to_json

      actual = @externalizer.convert(input)
      assert_equal(expected, actual)
    end

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
