class ProcedureRules
  include TestSupport

  def initialize(mocks = {})
    collaborators_start_as(:procedure_source => Procedure,
                           :animal_source => Animal).unless_overridden_by(mocks)
  end

  def add_excluded_pairs(pairs)
    all_procedures = procedure_source.all
    all_animals = animal_source.all
    all_procedures.each do | procedure | 
      procedure.exclusion_rules.each do | rule | 
        rule.add_excluded_pairs(pairs, all_animals)
      end
    end
  end

end

module Rule
  class Base

    attr_reader :owning_procedure

    def initialize(owning_procedure)
      @owning_procedure = owning_procedure
    end

    def add_excluded_pairs(collector, animals)
      excluded = animals.find_all { | a | animal_excluded?(a) }
      new_pairs = excluded.collect { | a | [owning_procedure, a] }
      collector.insert(-1, *new_pairs)
    end

    def animal_excluded?(animal); subclass_responsibility; end
  end

  def self.subclass(name, body) 
    eval "class Rule::#{name.to_s} < Base
            def animal_excluded?(animal)
                  #{body}
            end
          end"
  end

  subclass :HorsesOnly, %q{  animal.procedure_description_kind != 'equine' }
  subclass :BovineOnly, %q{  animal.procedure_description_kind != 'bovine' }
end
