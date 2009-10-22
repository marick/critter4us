module Rule
  class Base

    attr_reader :owning_procedure

    def initialize(owning_procedure)
      @owning_procedure = owning_procedure
    end

    def excluded_pairs(animals)
      excluded = animals.find_all { | a | animal_excluded?(a) }
      excluded.collect { | a | [owning_procedure, a] }
    end

    def animal_excluded?(animal); subclass_responsibility; end
  end
end
