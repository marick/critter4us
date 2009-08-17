require 'config'
require 'pp'

class Procedure  < Sequel::Model
  one_to_many :uses

  def self.names; map(:name); end

  # self description / testing

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

class Animal < Sequel::Model
  one_to_many :uses

  # self description / testing

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


class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
  many_to_one :reservation
end


