require './test/testutil/requires'
require './strangled-src/model/requires'
require './strangled-src/model/rules'

class RulesTest < FreshDatabaseTestCase

  def exclusion_tester(rule_class, hash)
    excluded_animals = hash[:excluded]
    just_fine_animals = hash[:just_fine]
    procedure = flexmock(:name => "some procedure")
    rule = rule_class.new(procedure)
    collector = ['...']
    rule.add_excluded_pairs(collector, excluded_animals+just_fine_animals)
    assert { collector.length == 1 + excluded_animals.size }
    assert { collector[0] == '...' }
    excluded_animals.each do | excluded | 
      assert { collector.include? [procedure, excluded] }
    end
  end

  should "include HorsesOnly" do
    exclusion_tester(Rule::HorsesOnly, 
                     :excluded => [
                                   flexmock(:procedure_description_kind => 'bovine'),
                                   flexmock(:procedure_description_kind => 'caprine'),
                                  ],
                     :just_fine => [
                                    flexmock(:procedure_description_kind => 'equine'),
                                   ])
  end

  should "include BovineOnly" do
    exclusion_tester(Rule::BovineOnly, 
                     :excluded => [
                                   flexmock(:procedure_description_kind => 'caprine'),
                                   flexmock(:procedure_description_kind => 'equine'),
                                  ],
                     :just_fine => [
                                    flexmock(:procedure_description_kind => 'bovine'),
                                   ])
  end

  should "include NoGoats" do
    exclusion_tester(Rule::NoGoats, 
                     :excluded => [
                                   flexmock(:procedure_description_kind => 'caprine'),
                                  ],
                     :just_fine => [
                                    flexmock(:procedure_description_kind => 'equine'),
                                    flexmock(:procedure_description_kind => 'bovine'),
                                   ])
  end

  should "include GoatsOnly" do
    exclusion_tester(Rule::GoatsOnly, 
                     :excluded => [
                                   flexmock(:procedure_description_kind => 'equine'),
                                   flexmock(:procedure_description_kind => 'bovine'),
                                  ],
                     :just_fine => [
                                    flexmock(:procedure_description_kind => 'caprine'),
                                   ])
  end

  should "include RuminantsOnly" do
    exclusion_tester(Rule::RuminantsOnly, 
                     :excluded => [
                                   flexmock(:procedure_description_kind => 'equine'),
                                  ],
                     :just_fine => [
                                   flexmock(:procedure_description_kind => 'bovine'),
                                    flexmock(:procedure_description_kind => 'caprine'),
                                   ])
  end

end

