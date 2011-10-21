require 'pp'

class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
  many_to_one :group

  @reservation_source = Reservation
  def self.override_reservation_source(val); @reservation_source = val; end

  def reservation
    group.reservation
  end

  def self.overlapping(timeslice)
    reservations = @reservation_source.overlapping(timeslice)
    reservations.collect { | r |
      r.uses
    }.flatten
  end

  def self.animals_in_use_during(timeslice)
    overlapping(timeslice).collect { | u | u.animal }
  end
end
