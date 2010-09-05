require 'model/query-maker'
require 'model/timeslice'

class TupleCache
  include TestSupport

  def initialize
    collaborators_start_as(:query_maker => QueryMaker.new)
  end

  def animals_still_working_hard_on(date)
    @animals_still_working_hard_on ||= 
      @query_maker.to_select_appropriate(:animal_name) do | q |
        q.begin_with(:animals, :excluded_because_in_use)
        q.restrict_to_tuples_in_use_on_or_after(date)
      end
  end
  
  def all_animals
    @all_animals ||= 
      @query_maker.to_select_appropriate(:animal_name, :animal_kind) do | q | 
        q.begin_with(:animals)
      end
  end
    
  def all_procedures
    @all_procedures ||=
      @query_maker.to_select_appropriate(:procedure_name) do | q | 
        q.begin_with(:procedures)
      end
  end

  def animals_ever_out_of_service
    @animals_ever_out_of_service ||= 
      @query_maker.to_select_appropriate(:animal_name) do | q | 
        q.begin_with(:animals)
        q.restrict_to_tuples_with_animals_ever_out_of_service
      end
  end

  def animals_out_of_service(timeslice)
    @animals_out_of_service_during_timeslice ||=
      @query_maker.to_select_appropriate(:animal_name) do | q | 
        q.begin_with(:animals)
        q.restrict_to_tuples_with_animals_out_of_service(timeslice)
      end
  end

  def animals_in_service(timeslice)
    @animals_in_service_during_timeslice ||=
      @query_maker.to_select_appropriate(:animal_name) do | q | 
        q.begin_with(:animals)
        q.restrict_to_tuples_with_animals_in_service(timeslice)
      end
  end

  def animals_with_procedure_conflicts
    @animals_with_procedure_conflicts ||=
      tuples = @query_maker.to_select_appropriate(:procedure_name, :animal_name) do | q | 
        q.begin_with(:excluded_because_of_animal, :animals, :procedures)
      end
  end

  def animals_blacked_out(timeslice)
    @animals_blacked_out ||= 
      @query_maker.to_select_appropriate(:procedure_name, :animal_name, :reservation_id) do | q | 
        q.begin_with(:excluded_because_of_blackout_period, :animals, :procedures)
        q.restrict_to_tuples_with_blackout_periods_overlapping(timeslice)
      end
  end

  def animals_in_use(timeslice)
    @animals_in_use ||=
      @query_maker.to_select_appropriate(:animal_name, :reservation_id) do | q | 
        q.begin_with(:animals, :excluded_because_in_use)
        q.restrict_to_tuples_with_animals_in_use_during(timeslice)
      end
  end

  def animal_usage(timeslice)
    @animals_and_procedures_used_during ||= 
      @query_maker.to_select_appropriate(:animal_name, :procedure_name) do | q | 
        q.begin_with_flattened_reservations
        q.restrict_to_tuples_overlapping(timeslice)
      end
  end
end
