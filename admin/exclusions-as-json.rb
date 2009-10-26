require 'config'
require 'model/requires'
require 'json'


def ruby_hash
  all_animals = Animal.all
  all_procedures = Procedure.all

  cache = {}
  all_procedures.each do | procedure | 
    # pp procedure
    # pp exclusion_rules(procedure)
    exclusion_rules(procedure).each do | rule | 
      # puts "applying #{rule} to #{procedure.name} with #{cache[procedure.id]}"
      excluded = all_animals.find_all { | a | rule.animal_excluded?(a) }.collect { | a | 
        a.name
      }
      cache[procedure.name] = excluded
    end
  end
  cache
end


def exclusion_rules(procedure)
  DB[:exclusion_rules].filter(:procedure_id => procedure.id).collect do | row | 
    Rule.const_get(row[:rule]).new(procedure)
  end
end

puts "TimeInvariantExclusionCache = #{ruby_hash.to_json.inspect}"

