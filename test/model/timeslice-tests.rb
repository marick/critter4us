$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class TimesliceTests < Test::Unit::TestCase

  def setup
    @date=Date.new(2009, 12, 12)
    @morning = true
  end

  context "exclusion maps" do
    setup do 
      @timeslice = Timeslice.new(mocks(:use_source, :procedure_source, :hash_maker))
      @timeslice.move_to(@date, @morning)
    end

    should "coordinate procedures and uses to create a hash" do 
      during {
        @timeslice.exclusions
      }.behold! { 
        @procedure_source.should_receive(:names).
                          and_return(procedure_names = 'a list of procedure names')
        @use_source.should_receive(:combos_unavailable_at).with(@date, @morning).
                    and_return(pairs = 'pairs of procedure and animal names')
        @hash_maker.should_receive(:keys_and_pairs).
                    with(procedure_names, pairs).
                    and_return('a hash')
      }
      assert { @result == 'a hash' }
    end
  end
end

