$: << '../../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'model/rules/requires'

class HorsesOnlyRuleTest < FreshDatabaseTestCase

  should "exclude horses" do
    rule = Rule::HorsesOnly.new("a procedure")
    in_the_pair = flexmock(:procedure_description_kind => 'bovine')
    out_of_the_pair = flexmock(:procedure_description_kind => 'equine')

    collector = ['...']
    rule.add_excluded_pairs(collector, [out_of_the_pair, in_the_pair])
    one = '...'
    assert { collector == [ '...', ["a procedure", in_the_pair] ] }
  end

end

