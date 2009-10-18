require 'pp'

class ProcedureDescription < Sequel::Model
  CATCHALL_KIND='any species'

  many_to_one :procedure
  alias_method :unique_identifier, :pk

  def self.procedure_descriptions_for(procedure)
    descriptions = ProcedureDescription.filter(:procedure_id => procedure.id).all
    Hash[*descriptions.collect { | p | [p.animal_kind, p]}.flatten]
  end
  # Probably a better name, but previous name created by global find/replace
  # (no refactoring).
  class << self
    alias_method :descriptions_for, :procedure_descriptions_for
  end

  # following are for testing

  def self.random(overrides = {})
    defaults = {
      :animal_kind => CATCHALL_KIND,
      :procedure => Procedure.random,
      :description => 'some procedure description'
    }
    create(defaults.merge(overrides))
  end

  class Null
    attr_reader :animal_kind

    def initialize(procedure, animal_kind = nil)
      @procedure = procedure
      @animal_kind = animal_kind
      @animal_kind ||= ProcedureDescription::CATCHALL_KIND
    end

    def unique_identifier
      "no_description_for_#{@procedure.pk}_and_#{@animal_kind.gsub(/ /,'_')}"
    end
    
    def description
      "<b>#{@procedure.name} (#{@animal_kind})</b>: The description for this procedure has not been written yet."
    end
  end


end

