require 'util/requires'

class Timeslice
  include TestSupport

  def move_to(date, time, ignoring = nil)
    @date = date
    @time = time
    @ignored_reservation = ignoring || unsaved_empty_reservation
  end


  def add_excluded_pairs(pairs)
    overlaps =  pairs_with_exclusion_range_overlapping_now
    inuse = multiply_by_procedures(animals_to_be_considered_in_use)
    # pp overlaps
    # pp inuse
    result = (overlaps + inuse).uniq
    pairs.insert(-1, *result)
  end

  def available_animals_by_name
    in_service = Animal.filter(:date_removed_from_service => nil).union(
                 Animal.filter(:date_removed_from_service > @date)).all
    animals = (in_service - animals_to_be_considered_in_use).uniq
    animals.collect { | a | a.name }  # &:name not built in at Heroku (1.8.6)
  end

  private

  def animals_now_in_use
    Use.at(@date, @time).collect { | u | u.animal }.uniq
  end

  def animals_to_be_considered_in_use
    animals_now_in_use - @ignored_reservation.animals
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
      exclude(:reservations__id => @ignored_reservation.id).
      filter(:procedures__days_delay > 0).
      filter(:procedures__id => :uses__procedure_id).
      filter(:animals__id => :uses__animal_id).
      filter(:groups__id => :uses__group_id).
      filter(:reservations__id => :groups__reservation_id).
      filter(:reservations__date - :procedures__days_delay + 1 <= @date).
      filter(:reservations__date + :procedures__days_delay > @date).
      select(:procedures__id.as(:procedure_id), 
             :animals__id.as(:animal_id),
             :reservations__id.as(:reservations_id))

    query.collect { | row |
      proc = Procedure[row[:procedure_id]]
      animal = Animal[row[:animal_id]]
#      pp [proc.name, animal.name, row[:reservation_id]]
      [proc, animal]
    }
  end

  require 'ostruct'
  def unsaved_empty_reservation
    o = OpenStruct.new(:animals => [])
    def o.id; -1; end   # Otherwise, get "Object#id will be deprecated"
    o
  end
end
