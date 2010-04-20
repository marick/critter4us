require 'pp'
require 'model/requires'

class ExclusionRule < Sequel::Model
  many_to_one :procedure
end

class Procedure  < Sequel::Model
  one_to_many :uses

  def self.names; map(:name); end
  def self.sorted_names; names.sort; end

  def exclusion_rules
    DB[:exclusion_rules].filter(:procedure_id => self.id).collect do | row | 
      Rule.const_get(row[:rule]).new(self)
    end
  end

  def self.note_excluded_animals(animals)
    DB[:exclusion_rules].all do | row | 
      rule_class = Rule.const_get(row[:rule])
      procedure = Procedure[row[:procedure_id]]
      rule = rule_class.new(procedure)
      animals.each do | animal | 
        if rule.animal_excluded?(animal)
          DB[:excluded_because_of_animal].insert(:animal_id => animal.id,
                                                 :procedure_id => procedure.id)
        end
      end
    end
  end

  # following are for testing

  def self.random(overrides = {})
    defaults = {
      :name => 'procedure',
      :days_delay => 3
    }
    create(defaults.merge(overrides));
  end

  def self.random_with_names(*names)
    names.each do | name | 
      random(:name => name)
    end
  end

end

