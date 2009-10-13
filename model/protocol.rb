require 'pp'

class Protocol < Sequel::Model
  many_to_one :procedure

  def self.protocols_for(procedure)
    protocols = Protocol.filter(:procedure_id => procedure.id).all
    Hash[*protocols.collect { | p | [p.animal_kind, p]}.flatten]
  end

  # following are for testing

  def self.random(overrides = {})
    defaults = {
      :animal_kind => 'all',
      :procedure => Procedure.random,
      :description => 'some protocol description'
    }
    create(defaults.merge(overrides))
  end
end
