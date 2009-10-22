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
      procedure.rules do | rule | 
        rule.add_excluded_pairs(pairs, procedure, all_animals)
      end
    end
  end

end
