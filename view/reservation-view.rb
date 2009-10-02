require 'view/util'

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
