require 'pp'

class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
  many_to_one :group

  def reservation
    group.reservation
  end

  def self.at(date, time)
    Reservation.filter(:date => date, :time => time).collect { | r |
      r.uses
    }.flatten
  end

end



