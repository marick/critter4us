require 'util/requires'
require 'model/exclusion-maker'

class ProcedureOverlaps < ExclusionMaker
  def initialize(date, time, ignored_reservation = Reservation.acts_as_empty)
    @date = date
    @time = time # currently ignored
    @ignored_reservation = ignored_reservation
  end

  def calculate
    query = DB[:procedures, :animals, :uses, :groups, :reservations].
      filter(:procedures__days_delay > 0).
      filter(:procedures__id => :uses__procedure_id).
      filter(:animals__id => :uses__animal_id).
      filter(:groups__id => :uses__group_id).
      filter(:reservations__id => :groups__reservation_id).
      filter(:reservations__date - :procedures__days_delay + 1 <= @date).
      filter(:reservations__date + :procedures__days_delay > @date)

    unless @ignored_reservation.acts_as_empty?
      query = query.exclude(:reservations__id => @ignored_reservation.id)
    end

    @raw_data = query.select(:procedures__id.as(:procedure_id), 
                             :animals__id.as(:animal_id),
                             :reservations__id.as(:reservations_id)).all
    nil
  end

  def as_map(procedures, animals)
    retval = listhash_with_keys(procedures)

    animals_by_id = object_by_id(animals)
    procedures_by_id = object_by_id(procedures)

    @raw_data.collect { | row | 
      proc = procedures_by_id[row[:procedure_id]]
      animal = animals_by_id[row[:animal_id]]
      retval[proc] << animal if animal
    }
    retval
  end
    
  # For historical reasons, this is used in some tests.
  def as_pairs(procedures, animals)
    listhash = as_map(procedures, animals)
    retval = []
    listhash.each do | procedure, list |
      list.each do | animal | 
        retval << [procedure, animal]
      end
    end
    retval
  end
end

