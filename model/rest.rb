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


class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
  many_to_one :group

  def reservation
    group.reservation
  end
end

class Group < Sequel::Model
  many_to_one :reservation
  one_to_many :uses

  def before_destroy
    uses.each { | use | use.destroy }
  end

  def in_wire_format
    collect_each(:procedure)
    collect_each(:animal)
    { 
      'procedures' => collect_each(:procedure),
      'animals' => collect_each(:animal),
    }
  end

  private

  def collect_each(attribute)
    uses.collect { |use| use.send(attribute).in_wire_format }.uniq.sort
  end
      
end


