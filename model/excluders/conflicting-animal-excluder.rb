require 'util/requires'

class ConflictingAnimalExcluder < ExcluderShape
  def as_map(timeslice)
    retval = listhash_with_keys(timeslice.procedures)
    procedures_by_id = object_by_id(timeslice.procedures)
    
    DB[:exclusion_rules].all.collect do | row | 
      procedure = procedures_by_id[row[:procedure_id]]
      rule = Rule.const_get(row[:rule]).new(procedure)
      excluded = timeslice.animals_in_service.find_all do | a | 
        rule.animal_excluded?(a)
      end
      retval[procedure] = excluded
    end
    retval
  end
end
