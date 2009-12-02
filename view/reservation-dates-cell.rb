require 'view/util'

class ReservationDatesCell < Erector::Widget
  include ViewHelper
  needs :reservations

  def content
    rawtext(@reservations.collect { | r | linky(r) }.join(', '))
  end

  def linky(reservation)
    erector { 
        a(reservation.date.to_s, 
          :href => "reservation/#{reservation.id}",
          :target => "_blank")
    }
  end
end
