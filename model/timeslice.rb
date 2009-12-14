require 'util/requires'
require 'model/requires'

class Timeslice
  include TestSupport

  def initialize(*args)
    super
    collaborators_start_as(:animal_source => Animal, 
                           :procedure_source => Procedure,
                           :use_source => Use)
    self
  end


  def move_to(date, time, ignoring = nil)
    @date = date
    @time = time
    @ignored_reservation = ignoring || Reservation.acts_as_empty

    @animals_in_service = nil
    @animals_that_can_be_reserved = nil
    @animals_to_be_considered_in_use = nil
    @procedures = nil
  end

  def animals_in_service
    return @animals_in_service if @animals_in_service

    @animals_in_service = animal_source.all_in_service_on(@date)
  end

  def animals_to_be_considered_in_use
    return @animals_to_be_considered_in_use if @animals_to_be_considered_in_use

    in_use = use_source.animals_in_use_at(@date, @time)
    @animals_to_be_considered_in_use = in_use - @ignored_reservation.animals
  end

  def animals_that_can_be_reserved
    return @animals_that_can_be_reserved if @animals_that_can_be_reserved

    @animals_that_can_be_reserved = (animals_in_service - animals_to_be_considered_in_use)
  end


  def procedures
    return @procedures if @procedures
    @procedures = procedure_source.all.sort { | a, b |
      a.name.downcase <=> b.name.downcase 
    }
  end

  def exclusions_due_to_other_reservations
    overlaps = ProcedureOverlaps.new(@date, @time, @ignored_reservation)
    overlaps.calculate
    retval = overlaps.as_map(procedures, animals_that_can_be_reserved)

    procedures.each do | p | 
      retval[p] += animals_to_be_considered_in_use
      retval[p].uniq!
      retval[p].sort!  # Sorting is just for testing.
    end

    retval
  end

  def exclusions_due_to_procedure_vs_animal_mismatch(mismatches = AnimalProcedureMismatches.new)
    mismatches.calculate
    mismatches.as_map(procedures, animals_in_service)
  end

  def hashes_from_animals_to_pending_dates(animals)
    animals.collect do | animal | 
      { animal => animal.dates_used_after_beginning_of(@date) } 
    end
  end
end
