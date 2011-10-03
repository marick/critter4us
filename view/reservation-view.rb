require './view/util'
require './view/reservation-view-prelude'

class ReservationView < Erector::Widget
  include ViewHelper
  include ReservationHelper

  def initialize(*args)
    super(*args)
    @procedure_descriptions = []
  end

  def content
    html do 
      head do
        title "Reservation #{@reservation.id}"
      end
      body do
        p { long_form(@reservation) }
        group_table(@reservation.groups)
        general_instructions
        procedure_descriptions
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
              link_procedure_name_to_description(name, group.animals)
            end
          end
        end
      end
    end
  end

  def link_procedure_name_to_description(name, animals)
    procedure = Procedure[:name => name]
    partial = ProcedurePartial.for(procedure, *animals)
    rawtext(partial.linkified_procedure_name)
    partial.add_name_anchored_descriptions_to(@procedure_descriptions)
  end

  def general_instructions
    rawtext ReservationViewPrelude.new(:procedure_description_kinds => @reservation.procedure_description_kinds).to_pretty
  end


  def procedure_descriptions
    @procedure_descriptions.each do | description | 
      div do
        rawtext description
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
