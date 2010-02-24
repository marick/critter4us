$: << '../../..' unless $in_rake
require 'test/testutil/requires'
require 'model/excluders/requires'
require 'model/requires'


class ReservedAnimalExcluderTest < Test::Unit::TestCase
  def setup
    super
    @timeslice = flexmock('timeslice')
    @excluder = ReservedAnimalExcluder.new

    @procedure = Procedure.new(:name => 'procedure')
    @other = Procedure.new(:name => 'other')
    @betsy = Animal.new(:name => 'betsy')
    @jake = Animal.new(:name => 'jake')
    @animals = [@betsy, @jake]

    during {
      @excluder.as_map(@timeslice)
    }.behold! {
      @timeslice.should_receive(:procedures).once.
                 and_return([@procedure, @other])
      @timeslice.should_receive(:animals_to_be_considered_in_use).once.
                 and_return(@animals)
    }
  end

  should "multiply animals reserved at timeslice moment by procedures" do
    expected = { @procedure => [@betsy, @jake],
                 @other => [@betsy, @jake] }
    assert_equal(expected, @result)
  end

  should "not share arrays" do
    assert { @result[@procedure].object_id != @animals.object_id }
    assert { @result[@other].object_id != @animals.object_id }
    assert { @result[@procedure].object_id != @result[@other].object_id }
  end
end
