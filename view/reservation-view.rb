require 'view/util'
require 'view/reservation-view-prelude'

class ReservationView < Erector::Widget
  include ReservationHelper

  def initialize(*args)
    super(*args)
    @protocol_descriptions = []
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
        protocols
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
              link_procedure_name_to_protocol(name, group.animals)
            end
          end
        end
      end
    end
  end

  def link_procedure_name_to_protocol(name, animals)
    procedure = Procedure[:name => name]
    partial = ProtocolPartial.for(procedure, *animals)
    rawtext(partial.linkified_procedure_name)
    partial.add_name_anchored_descriptions_to(@protocol_descriptions)
  end

  def general_instructions
    rawtext ReservationViewPrelude.new(:protocol_kinds => @reservation.protocol_kinds).to_pretty
  end


  def protocols
    @protocol_descriptions.each do | description | 
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
