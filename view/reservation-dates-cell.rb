require 'view/util'

class ReservationDatesCell < Erector::Widget
  include ViewHelper
  needs :reservations

  def content
    rawtext(@reservations.collect { | r | linky(r) }.join(', '))
  end

  def linky(reservation)
    as_shown = if (reservation.first_date != reservation.last_date)
                 "#{reservation.first_date.to_s} to #{reservation.last_date.to_s}"
               else
                 reservation.first_date.to_s
               end
    erector { 
        a(as_shown, 
          :href => "reservation/#{reservation.id}",
          :target => "_blank")
    }
  end
end
