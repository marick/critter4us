require 'util/requires'
require 'model/requires'

# TODO: The boundaries between Availability, TupleCache, and
# QueryMaker are fairly clear, but the tests slop back and forth over
# them.

class Availability
  include TestSupport

  def self.without_timeslice
    new(nil)
  end

  def initialize(timeslice, reservation_id_to_ignore = nil)
    @timeslice = timeslice
    @reservation_id_to_ignore = reservation_id_to_ignore
    collaborators_start_as(:query => QueryMaker.new,
                           :reshaper => Reshaper.new,
                           :tuple_cache => TupleCache.new)
  end

  def animals_and_procedures_and_exclusions
    { :animals => animals_that_can_be_reserved,
      :procedures => procedures_that_can_be_assigned,
      :kindMap => kind_map,
      :timeSensitiveExclusions => exclusions_due_to_reservations,
      :timelessExclusions => exclusions_due_to_animal
    }
  end

  def animals_that_can_be_reserved
    all_animals - animals_prohibited_for_this_timeslice
  end

  def kind_map
    relevant_animals = all_animals - animals_already_out_of_service
    relevant_tuples = @tuple_cache.all_animals.find_all do | tuple | 
      relevant_animals.include?(tuple[:animal_name])
    end
    @reshaper.pairs_to_hash(relevant_tuples, :animal_name, :animal_kind)
  end

  def procedures_that_can_be_assigned
    @reshaper.tuples_to_presentable_array(@tuple_cache.all_procedures, :procedure_name)
  end

  def exclusions_due_to_reservations
    map = KeyToValuelistMap.new(procedures_that_can_be_assigned)
    map.spread_values_among_keys(animals_prohibited_for_this_timeslice)
    tuples = without_reservation_tuples(@tuple_cache.animals_blacked_out(@timeslice))
    map.add_specific_pairs(tuples, :procedure_name, :animal_name)
    map
  end

  def exclusions_due_to_animal
    map = KeyToValuelistMap.new(procedures_that_can_be_assigned)
    relevant_animals = animals_that_can_be_reserved
    relevant_tuples = @tuple_cache.animals_with_procedure_conflicts.find_all do | tuple | 
      relevant_animals.include?(tuple[:animal_name])
    end
    map.add_specific_pairs(relevant_tuples, :procedure_name, :animal_name)
    map
  end

  def all_animals
    @reshaper.tuples_to_presentable_array(@tuple_cache.all_animals, :animal_name)
  end

  def animals_that_can_be_removed_from_service
    date = @timeslice.first_date
    raw_data = [@tuple_cache.animals_still_working_hard_on(date),
                @tuple_cache.animals_ever_out_of_service,
                @tuple_cache.all_animals]
    animals_still_working_hard, animals_ever_out_of_service, all_animals = 
      raw_data.collect { | tuples | 
         @reshaper.tuples_to_presentable_array(tuples, :animal_name) 
      }
    @reshaper.presentable(all_animals - animals_still_working_hard - animals_ever_out_of_service)
  end

  def animals_prohibited_for_this_timeslice
    tuples = @tuple_cache.animals_out_of_service(@timeslice)
    tuples += without_reservation_tuples(@tuple_cache.animals_in_use(@timeslice))
    @reshaper.tuples_to_presentable_array(tuples, :animal_name)
  end

  def animals_already_out_of_service
    @reshaper.tuples_to_presentable_array(@tuple_cache.animals_out_of_service(@timeslice), :animal_name)
  end

  private

  def without_reservation_tuples(tuples)
    return tuples unless @reservation_id_to_ignore
    tuples.reject { | tuple | tuple[:reservation_id] == @reservation_id_to_ignore }
  end
end
