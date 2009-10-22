require 'util/requires'

class Timeslice
  include TestSupport

  def move_to(date, morning)
    @date = date
    @morning = morning
  end


  def add_excluded_pairs(pairs)
    # pp pairs_with_exclusion_range_overlapping_now
    # pp multiply_by_procedures(animals_now_in_use)
    result = (pairs_with_exclusion_range_overlapping_now +
              multiply_by_procedures(animals_now_in_use)).uniq
    pairs.insert(-1, *result)
  end

  def available_animals_by_name
    (Animal.all - animals_now_in_use).collect { | a | a.name }
  end

  private

  def animals_now_in_use
    Use.at(@date, @morning).collect { | u | u.animal }
  end

  def multiply_by_procedures(animals)
    retval = []
    Procedure.each { | procedure |
      animals.each { | animal | 
        retval << [procedure, animal]
      }
    }
    retval.uniq
  end


  def pairs_with_exclusion_range_overlapping_now
    query = DB[:procedures, :animals, :uses, :groups, :reservations].
      filter(:procedures__days_delay > 0).
      filter(:procedures__id => :uses__procedure_id).
      filter(:animals__id => :uses__animal_id).
      filter(:groups__id => :uses__group_id).
      filter(:reservations__id => :groups__reservation_id).
      filter(:reservations__date - :procedures__days_delay + 1 <= @date).
      filter(:reservations__date + :procedures__days_delay > @date).
      select(:procedures__id.as(:procedure_id), 
             :animals__id.as(:animal_id))

    query.collect { | row |
      [Procedure[row[:procedure_id]],
       Animal[row[:animal_id]]]
    }
  end
end
