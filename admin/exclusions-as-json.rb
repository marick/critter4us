require 'config'
DB.logger = nil
require 'model/requires'
require 'json'

# DB.logger = Logger.new($stderr);


def ruby_hash
  all_animals = Animal.all

  cache = {}
  animal_excluders.each do | excluder |
    excluded = all_animals.find_all { | a | 
      excluder.animal_excluded?(a)
    }.collect { | a | 
      a.name
    }
    cache[excluder.owning_procedure.name] = excluded
  end
#  pp cache
  cache
end


def animal_excluders
  rules = ExclusionRule.eager(:procedure).all
  rules.collect do | rule |  
    Rule.const_get(rule.rule).new(rule.procedure)
  end
end

puts "TimeInvariantExclusionCache = #{ruby_hash.to_json.inspect}"
