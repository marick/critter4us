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
end
