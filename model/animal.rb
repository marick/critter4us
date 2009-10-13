require 'pp'

class Animal < Sequel::Model
  one_to_many :uses

  def self.names; map(:name); end

  # This doesn't work under 1.8.7 / Snow Leopard - perhaps because name isn't defined yet.
  # alias_method :in_wire_format, :name    
  def in_wire_format; name; end

  def self.kind_map
    map = {}
    Animal.all.each { | a | map[a.name] = a.kind }
    map
  end

  def self.available_on(hash)
    date = hash(:date)
    morning = hash(:morning)
  end


  def protocol_kind
    DB[:human_and_protocol_kinds].filter(:kind => self.kind).first[:protocol_kind]
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

