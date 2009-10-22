$: << '../../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'model/rules/requires'

class HorsesOnlyRuleTest < FreshDatabaseTestCase

  should "exclude horses" do
    procedure = OpenStruct.new
    in_the_pair = OpenStruct.new(:procedure_description_kind => 'bovine')
    out_of_the_pair = OpenStruct.new(:procedure_description_kind => 'equine')
    result = Rule::HorsesOnly.new.excluded_pairs(procedure, [out_of_the_pair, in_the_pair])
    assert { result == [ [procedure, in_the_pair] ] }
  end

end

