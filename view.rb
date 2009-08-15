require 'erector'

module ReservationHelper
  def time_of_day(reservation)
    if reservation.morning
      "morning"
    else
      "afternoon"
    end
  end

  def long_form(reservation)
    text "Reservation for the #{time_of_day(reservation)} of #{reservation.date},"
    text " made by "
    a "#{reservation.instructor}@illinois.edu",
    :href=>"mailto:#{reservation.instructor}@illinois.edu"
    text " for #{reservation.course}."
  end

end


class ReservationListView < Erector::Widget
  include ReservationHelper

  def content
    html do 
      head do
        title 'All Reservations'
      end
      body do
        sorted_reservations.each do | r | 
          p do 
            long_form(r)
            br
            rawtext "&nbsp;"*8
            text r.animal_names.join(', ') 
            br
            rawtext "&nbsp;"*8
            text r.procedure_names.join(', ') 
          end
        end
      end
    end
  end

  def sorted_reservations
    @reservations.sort { |a, b|
      if a.date != b.date
        a.date <=> b.date
      elsif a.morning == b.morning
        0
      elsif a.morning
        -1
      else
        1
      end
    }
  end
end

class ReservationView < Erector::Widget
  include ReservationHelper

  def name_list(names)
    ul do
      names.each do | name | 
        li { text name }
      end
    end
  end

  def content
    html do 
      head do
        title "Reservation #{@reservation.id}"
      end
      body do
        p { long_form(@reservation) }
        p do
          text "These animals are reserved:"
          name_list(@reservation.animal_names)
        end
        p do 
          text "These procedures will be done:"
          name_list(@reservation.procedure_names)
        end
      end
    end
  end
end
