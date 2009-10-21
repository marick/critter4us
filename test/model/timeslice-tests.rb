$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class TimesliceTests < Test::Unit::TestCase

  def setup
    @date=Date.new(2009, 12, 12)
    @morning = true
    @timeslice = Timeslice.new(mocks(:use_source, :procedure_source, 
                                     :animal_source, :hash_maker))
    @timeslice.move_to(@date, @morning)
  end

  should "coordinate procedures and uses to create an exclusion hash" do 
    during {
      @timeslice.exclusions
    }.behold! { 
      @procedure_source.should_receive(:names).
                            and_return(procedure_names = 'a list of procedure names')
      @use_source.should_receive(:combos_unavailable_at).with(@date, @morning).                            and_return(pairs = [['pairs of', 'procedure'],                                                               ['and', 'animal names']])
      @hash_maker.should_receive(:keys_and_pairs).
                  with(procedure_names, pairs).
                  and_return('a hash')
    }
    assert { @result == 'a hash' }
  end

  should "allow animals to be included despite being in use (e.g., if editing reservation)" do 
    during {
      @timeslice.exclusions(:allowing_animals => ['fred'])
    }.behold! { 
      @procedure_source.should_receive(:names).
                            and_return(procedure_names = 'a list of procedure names')
      @use_source.should_receive(:combos_unavailable_at).with(@date, @morning).                            and_return([['floating', 'fred'], ['veni', 'betsy']])
      @hash_maker.should_receive(:keys_and_pairs).
                  with(procedure_names, [['veni', 'betsy']]).
                  and_return('a hash')
    }
    assert { @result == 'a hash' }
  end

  should "deliver animal names not in use during the timeslice" do
    during { 
      @timeslice.available_animals_by_name
    }.behold! {
      @animal_source.should_receive(:sorted_names).
                     and_return(names = 'some animal names')
      @use_source.should_receive(:remove_names_for_animals_in_use).
                  with(names, @date, @morning).
                  and_return(@winnowed = 'same list with some animals removed')
    }
    assert { @result == @winnowed }
  end
    
end

