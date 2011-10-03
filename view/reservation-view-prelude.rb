require './view/util'

class ReservationViewPrelude < Erector::Widget
  include ReservationHelper

  def content
    common_prelude
    specific_preludes
  end

  def common_prelude
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

  def specific_preludes
    @procedure_description_kinds.each do | kind | 
      p(b("For all #{kind} procedures:"))
      case kind
      when 'bovine'
        bovine_prelude
      when 'equine'
        equine_prelude
      when 'caprine'
        caprine_prelude
      else
        p("No description has been written yet.")
      end
    end
  end

  def bovine_prelude 
    if_restless('cattle')
    drug_list("Xylazine 0.01-0.05 mg/kg IV, 0.01-0.1 mg/kg IM",
             "Acepromazine 0.01-0.02 mg/kg IV, 0.02-0.05 mg/kg IM ",
             "Butarphanol 0.01-0.02 mg/kg IV, 0.02-0.05 mg/kg IM",
             "Ketamine 0.1-1.0 mg/kg IV, 0.5-2mg/kg IM")
    drug_notes
  end

  def equine_prelude
    if_restless('horses')
    drug_list("Xylazine 0.4-1.0 mg/kg IV, 1-2 mg/kg IM",
              "Detomidine 0.01-0.06 mg/kg IV or IM",
              "Romifidine 0.04-0.08 mg/kg IV or IM",
              "Butorphanol 0.05-0.1 mg/kg IV or IM")
    drug_notes
  end

  def caprine_prelude
    if_restless('goats')
    drug_list("Xylazine 0.01-0.05 mg/kg IV, 0.01-0.1 mg/kg IM",
              "Ketamine 0.5-2 mg/kg IM, 0.1-1 mg/kg IV",
              "Butorphanol 0.02-0.05 mg/kg IM, 0.01-0.02 mg/kg IV",
              "Acepromazine 0.02-0.05 mg/kg IM, 0.01-0.02 mg/kg IV")
    drug_notes
  end

  def if_restless(what)
    p("If #{what} appear nervous or restless, the following drugs may be administered to calm them and assure their safety and the safety of persons around them:")
  end

  def drug_list(*drugs)
    ul do 
      drugs.each do | drug |
        li { text drug }
      end
    end
  end

  def drug_notes
    text "*Only trained personnel listed on the IACUC protocol may administer drugs."
    p "Some procedures require that specific drug/doses be used."
    p do
      text "Drug use must be recorded in the animal's "
      b("medical record")
      text '.'
    end
  end
end
