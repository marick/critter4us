require 'util/requires'
require 'model/excluders/requires'

class ReservedAnimalExcluder < ExcluderShape
  def as_map(timeslice)
    listhash_with_keys(timeslice.procedures, timeslice.animals_to_be_considered_in_use)
  end
end
