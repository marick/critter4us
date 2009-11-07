require 'pp'

class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
  many_to_one :group

  def reservation
    group.reservation
  end

  def self.at(date, day_segment)
    Reservation.filter(:date => date, :day_segment => day_segment).collect { | r |
      r.uses
    }.flatten
  end

end



