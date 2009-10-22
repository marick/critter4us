require 'pp'

class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
  many_to_one :group

  def reservation
    group.reservation
  end

  def self.at(date, morning)
    Reservation.filter(:date => date, :morning => morning).collect { | r |
      r.uses
    }.flatten
  end

end



