require 'config'
require 'pp'

class Procedure  < Sequel::Model
  one_to_many :uses

  def self.names; map(:name); end
  alias_method :in_wire_format, :name

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

