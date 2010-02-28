require 'util/requires'
require 'model/requires'

Timeslice = Struct.new(:first_date, :last_date, :times, :ignored_reservation) do
  include TestSupport

  def self.degenerate(date, time, ignored_reservation)
    new(date, date, TimeSet.new(time), ignored_reservation)
  end

  def faked_date_TODO_replace_me
    first_date
  end

  def faked_time_TODO_replace_me
    times.to_a.first
  end

  def initialize(*args)
    super
    collaborators_start_as(:animal_source => Animal, 
                           :procedure_source => Procedure,
                           :use_source => Use)
    @animals_in_service = nil
    @animals_that_can_be_reserved = nil
    @animals_to_be_considered_in_use = nil
    @procedures = nil
  end

  def animals_in_service
    return @animals_in_service if @animals_in_service
    @animals_in_service = animal_source.all_in_service_on(last_date)
  end

  def animals_to_be_considered_in_use
    return @animals_to_be_considered_in_use if @animals_to_be_considered_in_use

    in_use = use_source.animals_in_use_during(self)
    @animals_to_be_considered_in_use = in_use - ignored_reservation.animals
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

  def hashes_from_animals_to_pending_dates(animals)
    animals.collect do | animal | 
      { animal => animal.dates_used_after_beginning_of(last_date) } 
    end
  end
end
