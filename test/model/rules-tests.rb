$: << '../../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'model/procedure-rules'

class RulesTest < FreshDatabaseTestCase

  def exclusion_tester(rule_class, in_the_pair, out_of_the_pair)
    rule = rule_class.new("a procedure")
    collector = ['...']
    rule.add_excluded_pairs(collector, [out_of_the_pair, in_the_pair])
    one = '...'
    assert { collector == [ '...', ["a procedure", in_the_pair] ] }
  end

  should "include HorsesOnly" do
    exclusion_tester(Rule::HorsesOnly, 
                     flexmock(:procedure_description_kind => 'bovine'),
                     flexmock(:procedure_description_kind => 'equine'))
  end

  should "include BovineOnly" do
    exclusion_tester(Rule::BovineOnly, 
                     flexmock(:procedure_description_kind => 'equine'),
                     flexmock(:procedure_description_kind => 'bovine'))
  end


end

