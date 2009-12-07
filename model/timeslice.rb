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

    @animals_at_all_available = nil
    @animals_to_be_considered_in_use = nil
    @procedures = nil
  end

  def animals_at_all_available_by_name
    animals_at_all_available.collect { | a | a.name }  # &:name not built in at Heroku (1.8.6)
  end

  def animals_at_all_available
    return @animals_at_all_available if @animals_at_all_available

    in_service = animal_source.all_in_service_on(@date)
    @animals_at_all_available = (in_service - animals_to_be_considered_in_use)
  end

  def animals_to_be_considered_in_use
    return @animals_to_be_considered_in_use if @animals_to_be_considered_in_use

    in_use = use_source.animals_in_use_at(@date, @time)
    @animals_to_be_considered_in_use = in_use - @ignored_reservation.animals
  end

  def procedures
    return @procedures if @procedures
    @procedures = procedure_source.all.sort { | a, b |
      a.name.downcase <=> b.name.downcase 
    }
  end

  def procedure_names
    procedures.collect { | p | p.name } 
  end

  def exclusions
    overlaps = ProcedureOverlaps.new(@date, @time, @ignored_reservation)
    overlaps.calculate
    retval = overlaps.as_map(procedures, animals_at_all_available)

    procedures.each do | p | 
      retval[p] += animals_to_be_considered_in_use
      retval[p].uniq!
    end

    retval
  end

  
  def exclusions_by_name
    retval = {}
    exclusions.each do | procedure, animal_list | 
      retval[procedure.name] = animal_list.map { | a | a.name }.sort
    end
    retval
  end

  def hashes_from_animals_to_pending_dates(animals)
    animals.collect do | animal | 
      { animal => animal.dates_used_after_beginning_of(@date) } 
    end
  end
end
