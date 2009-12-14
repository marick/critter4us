require 'util/requires'
require 'model/exclusion-maker'

class AnimalProcedureMismatches < ExclusionMaker

  def calculate
    # Just to adhere to protocol
  end

  def as_map(procedures, potential_animals)
    retval = listhash_with_keys(procedures)
    procedures_by_id = object_by_id(procedures)
    
    DB[:exclusion_rules].all.collect do | row | 
      procedure = procedures_by_id[row[:procedure_id]]
      rule = Rule.const_get(row[:rule]).new(procedure)
      excluded = potential_animals.find_all do | a | 
        rule.animal_excluded?(a)
      end
      retval[procedure] = excluded
    end
    retval
  end
end
