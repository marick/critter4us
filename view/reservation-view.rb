require 'view/util'

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
              link_procedure_name_to_protocol(name)
            end
          end
        end
      end
    end
  end

  def link_procedure_name_to_protocol(name)
    procedure = Procedure[:name => name]
    partial = ProtocolPartial.for(procedure)
    rawtext(partial.protocol_link)
    unless @protocol_descriptions.include?(partial.protocol_description) 
      @protocol_descriptions << partial.protocol_description 
    end
  end

  def general_instructions
    div do
      p do
        text %Q{All persons conducting or assisting with procedures on agricultural animals for teaching purposes must 1) be listed on the IACUC protocol, 2) have completed the online IACUC training module, and 3) be enrolled in the campus Occupational Health and Safety Program. To add an individual to the protocol, contact the Principal Investigator, Dr. Dennis French (}
        a("ddfrench@illinois.edu", :href => "mailto:ddfrench@illinois.edu")
        text ") or the Agricultural Animal Care and Use Program Office ("
        a("cpruitt@illinois.edu", :href => "mailto:cpruitt@illinois.edu")
        text "; 265-6790)."
      end

      p do
text "The methods and limits described for each procedure below were approved by the IACUC. You must adhere to the approved procedures. To request an amendment to the protocol, contact Dr. Dennis French or the Agricultural Animal Care and Use Program Office."
      end

      p do 
text "In addition to any specific limits mentioned below, animal responses should be used to determine the number and frequency of procedures to be performed. All procedures must be conducted under supervision of trained personnel who are experienced in recognizing signs of distress. Kicking, butting or other aggressive behaviors, attempts to escape, excessive vocalization, elevations in heart or respiratory rate, signs of 
tissue trauma, bleeding, or abnormal posture following a procedure are indications to discontinue the procedure."
      end
    end
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
