require 'config'
require 'pp'

class Animal < Sequel::Model
  one_to_many :uses

  def self.names; map(:name); end
  alias_method :in_wire_format, :name

  def self.kind_map
    map = {}
    Animal.all.each { | a | map[a.name] = a.kind }
    map
  end

  def self.available_on(hash)
    date = hash(:date)
    morning = hash(:morning)
  end
    

  # following are for testing

  def self.random(overrides = {})
    defaults = {
      :name => 'bossy',
      :kind => 'bovine'
    }
    create(defaults.merge(overrides));
  end

  def self.random_with_names(*names)
    names.each do | name | 
      random(:name => name)
    end
  end
end

