require 'pp'

class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
  many_to_one :group

  def reservation
    group.reservation
  end

  def self.overlapping(timeslice)
    date = timeslice.first_date
    time = timeslice.times.to_a[0]
    reservations = case time
                   when MORNING 
                     Reservation.filter(:first_date => date, :morning => true).all
                   when AFTERNOON
                     Reservation.filter(:first_date => date, :afternoon => true).all
                   when EVENING
                     Reservation.filter(:first_date => date, :evening => true).all
                   else
                     raise "Whats up?"
                   end
                     
    reservations.collect { | r |
      r.uses
    }.flatten
  end

  def self.animals_in_use_during(timeslice)
    overlapping(timeslice).collect { | u | u.animal }
  end
end
