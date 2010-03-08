require 'util/requires'
require 'model/requires'

class Availability
  include TestSupport

  def self.without_timeslice
    new(nil)
  end

  def initialize(timeslice, reservation_id_to_ignore = nil)
    @timeslice = timeslice
    @reservation_id_to_ignore = reservation_id_to_ignore
    collaborators_start_as(:query => QueryMaker.new,
                           :reshaper => Reshaper.new)
  end

  def animals_that_can_be_reserved
    all_animals - animals_prohibited_for_this_timeslice
  end

  def kind_map
    relevant_animals = animals_that_can_be_reserved
    relevant_tuples = tuples__all_animals.find_all do | tuple | 
      relevant_animals.include?(tuple[:animal_name])
    end
    @reshaper.pairs_to_hash(relevant_tuples, :animal_name, :animal_kind)
  end

  def procedures_that_can_be_assigned
    @reshaper.one_value_sorted_array(tuples__all_procedures, :procedure_name)
  end

  def exclusions_due_to_reservations
    map = KeyToValuelistMap.new(procedures_that_can_be_assigned)
    map.spread_values_among_keys(animals_prohibited_for_this_timeslice)
    map.add_specific_pairs(tuples__animals_blacked_out, :procedure_name, :animal_name)
    map
  end

  def exclusions_due_to_animal
    map = KeyToValuelistMap.new(procedures_that_can_be_assigned)
    relevant_animals = animals_that_can_be_reserved
    relevant_tuples = tuples__animals_with_procedure_conflicts.find_all do | tuple | 
      relevant_animals.include?(tuple[:animal_name])
    end
    map.add_specific_pairs(relevant_tuples, :procedure_name, :animal_name)
    map
  end

  def all_animals
    @reshaper.one_value_sorted_array(tuples__all_animals, :animal_name)
  end

  def animals_that_can_be_removed_from_service
    date = @timeslice.first_date
    animals_still_working_hard = 
      @reshaper.one_value_sorted_array(tuples__animals_still_working_hard_on(date),
                                       :animal_name)
    animals_out_of_service =
      @reshaper.one_value_sorted_array(tuples__animals_out_of_service, :animal_name)
    all_animals - animals_still_working_hard - animals_out_of_service
  end

  def animals_prohibited_for_this_timeslice
    tuples = tuples__animals_out_of_service + tuples__animals_in_use
    @reshaper.one_value_sorted_array(tuples, :animal_name)
  end

  # Tuples

  def tuples__all_animals
    @query.to_select_appropriate(:animal_name, :animal_kind) do | q | 
      q.begin_with(:animals)
    end
  end
    
  def tuples__animals_still_working_hard_on(date)
    @query.to_select_appropriate(:animal_name) do | q |
      q.begin_with(:animals, :excluded_because_in_use)
      q.restrict_to_tuples_in_use_on_or_after(date)
    end
  end
  
  def tuples__all_procedures
    @query.to_select_appropriate(:procedure_name) do | q | 
      q.begin_with(:procedures)
    end
  end

  def tuples__animals_out_of_service
    @query.to_select_appropriate(:animal_name) do | q | 
      q.begin_with(:animals)
      q.restrict_to_tuples_with_animals_out_of_service(@timeslice)
    end
  end

  def tuples__animals_with_procedure_conflicts
    tuples = @query.to_select_appropriate(:procedure_name, :animal_name) do | q | 
      q.begin_with(:excluded_because_of_animal, :animals, :procedures)
    end
  end

  def tuples__animals_blacked_out
    tuples = @query.to_select_appropriate(:procedure_name, :animal_name, :reservation_id) do | q | 
      q.begin_with(:excluded_because_of_blackout_period, :animals, :procedures)
      q.restrict_to_tuples_with_blackout_periods_overlapping(@timeslice)
    end
    without_reservation_tuples(tuples)
  end

  def tuples__animals_in_use
    tuples = @query.to_select_appropriate(:animal_name, :reservation_id) do | q | 
      q.begin_with(:animals, :excluded_because_in_use)
      q.restrict_to_tuples_with_animals_in_use_during(@timeslice)
    end
    without_reservation_tuples(tuples)
  end

  def without_reservation_tuples(tuples)
    return tuples unless @reservation_id_to_ignore
    tuples.reject { | tuple | tuple[:reservation_id] == @reservation_id_to_ignore }
  end
end
