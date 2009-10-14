require 'pp'

class Protocol < Sequel::Model
  CATCHALL_KIND='any species'

  many_to_one :procedure
  alias_method :unique_identifier, :pk

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
    attr_reader :animal_kind

    def initialize(procedure, animal_kind)
      @procedure = procedure
      @animal_kind = animal_kind
      @animal_kind ||= Protocol::CATCHALL_KIND
    end

    def unique_identifier
      "no_protocol_defined_for_#{@procedure.pk}_and_#{@animal_kind.gsub(/ /,'_')}"
    end
    
    def description
      "<b>#{@procedure.name} (#{@animal_kind})</b>: No protocol has yet been defined."
    end
  end


end

