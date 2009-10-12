require 'view/util'

class ReservationView < Erector::Widget
  include ReservationHelper

  def content
    html do 
      head do
        title "Reservation #{@reservation.id}"
      end
      body do
        p { long_form(@reservation) }
        group_table(@reservation.groups)
        rawtext protocols
      end
    end
  end

  def group_table(groups)
    table(TableStyle) do 
      groups.each do | group |
        tr do
          td do 
            name_list(group.animal_names) { | name | text name }
          end
          td do 
            name_list(group.procedure_names) do | name |
              procedure = Procedure[:name => name]
              rawtext(ProcedurePartial.new(procedure).protocol_link)
            end
          end
        end
      end
    end
  end


  def protocols
    @reservation.procedures.uniq.collect do | procedure |
      partial = ProcedurePartial.new(procedure)
      div do
        rawtext partial.protocol_name_anchor
        rawtext procedure.protocol
      end
    end
  end

  def name_list(names, &content_handler)  
    ul do
      names.each do | name | 
        li { content_handler.call(name) }
      end
    end
  end
end
