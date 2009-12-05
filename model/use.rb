require 'pp'

class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
  many_to_one :group

  def reservation
    group.reservation
  end

  def self.at(date, time)
    reservations = Reservation.filter(:date => date, :time => time).all
    reservations.collect { | r |
      r.uses
    }.flatten
  end

  def self.animals_in_use_at(date, time)
    at(date, time).collect { | u | u.animal }
  end

end



