require 'util/requires'

class ProcedureBlackoutPeriodExcluder < ExcluderShape

  def raw_data(timeslice)
    query = DB[:procedures, :animals, :uses, :groups, :reservations].
      filter(:procedures__days_delay > 0).
      filter(:procedures__id => :uses__procedure_id).
      filter(:animals__id => :uses__animal_id).
      filter(:groups__id => :uses__group_id).
      filter(:reservations__id => :groups__reservation_id).
      filter(:reservations__first_date - :procedures__days_delay + 1 <= timeslice.faked_date_TODO_replace_me).
      filter(:reservations__first_date + :procedures__days_delay > timeslice.faked_date_TODO_replace_me)

    unless timeslice.ignored_reservation.acts_as_empty?
      query = query.exclude(:reservations__id => timeslice.ignored_reservation.id)
    end

    query.select(:procedures__id.as(:procedure_id), 
                 :animals__id.as(:animal_id),
                 :reservations__id.as(:reservations_id)).all
  end

  def as_map(timeslice)
    retval = listhash_with_keys(timeslice.procedures)

    animals_by_id = object_by_id(timeslice.animals_that_can_be_reserved)
    procedures_by_id = object_by_id(timeslice.procedures)

    raw_data(timeslice).collect { | row | 
      proc = procedures_by_id[row[:procedure_id]]
      animal = animals_by_id[row[:animal_id]]
      retval[proc] << animal if animal
    }
    retval
  end
end

