require 'pp'

class Protocol < Sequel::Model
  CATCHALL_KIND='animalia'

  many_to_one :procedure

  def self.protocols_for(procedure)
    protocols = Protocol.filter(:procedure_id => procedure.id).all
    Hash[*protocols.collect { | p | [p.animal_kind, p]}.flatten]
  end

  # following are for testing

  def self.random(overrides = {})
    defaults = {
      :animal_kind => CATCHALL_KIND,
      :procedure => Procedure.random,
      :description => 'some protocol description'
    }
    create(defaults.merge(overrides))
  end

  class Null
    def initialize(procedure, protocol_kind)
      @procedure = procedure
      @protocol_kind = protocol_kind
      @protocol_kind ||= 'any species'
    end

    def pk
      "no_protocol_defined_for_#{@procedure.pk}_and_#{@protocol_kind.gsub(/ /,'_')}"
    end
    
    def description
      "<b>#{@procedure.name} (#{@protocol_kind})</b>: No protocol has yet been defined."
    end
  end


end

