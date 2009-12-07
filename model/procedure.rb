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

