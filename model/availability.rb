require 'util/requires'
require 'model/requires'

class Availability
  include TestSupport

  def initialize(timeslice, reservation_to_ignore = nil)
    @timeslice = timeslice
    @reservation_to_ignore = reservation_to_ignore
    collaborators_start_as(:query => QueryMaker.new,
                           :reshaper => Reshaper.new)
  end

  def animals_that_can_be_reserved
    all_animals - animals_prohibited_for_this_timeslice
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

  def all_animals
    @reshaper.one_value_sorted_array(tuples__all_animals, :animal_name)
  end

  def animals_prohibited_for_this_timeslice
    tuples = tuples__animals_out_of_service + tuples__animals_in_use
    @reshaper.one_value_sorted_array(tuples, :animal_name)
  end

  # Tuples

  def tuples__all_animals
    @query.to_select_appropriate(:animal_name) do | q | 
      q.begin_with(:animals)
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
    return tuples unless @reservation_to_ignore
    tuples.reject { | tuple | tuple[:reservation_id] == @reservation_to_ignore.id }
  end
end
