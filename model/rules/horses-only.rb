module Rule
  class HorsesOnly
    def excluded_pairs(procedure, animals)
      excluded = animals.find_all { | a | a.procedure_description_kind != 'equine' }
      excluded.collect { | a | [procedure, a] }
    end
  end
end
