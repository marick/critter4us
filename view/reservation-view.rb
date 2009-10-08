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
        group_table(@reservation.groups)
      end
    end
  end


  def group_table(groups)
    table(TableStyle) do 
      groups.each do | group |
        tr do
          td do 
            name_list(group.animal_names)
          end
          td do 
            name_list(group.procedure_names)
          end
        end
      end
    end
  end

end
