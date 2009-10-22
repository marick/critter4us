require 'model/rules/requires'

module Rule
  class HorsesOnly < Base
    def animal_excluded?(animal)
      animal.procedure_description_kind != 'equine'
    end
  end
end
