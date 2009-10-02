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
        @reservation.groups.each do | group | 
          p do
            text "These animals are reserved:"
            name_list(group.animal_names)
          end
          p do 
            text "These procedures will be done:"
            name_list(group.procedure_names)
          end
        end
      end
    end
  end
end
