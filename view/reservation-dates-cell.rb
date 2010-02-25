require 'view/util'

class ReservationDatesCell < Erector::Widget
  include ViewHelper
  needs :reservations

  def content
    rawtext(@reservations.collect { | r | linky(r) }.join(', '))
  end

  def linky(reservation)
    erector { 
        a(reservation.faked_date_TODO_replace_me.to_s, 
          :href => "reservation/#{reservation.id}",
          :target => "_blank")
    }
  end
end
