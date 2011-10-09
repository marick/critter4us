require './view/util'
require 'RedCloth'

class ReservationNoteView < Erector::Widget     
  include ViewHelper
  include ReservationHelper

  def content
    html do 
      head do
        title 'Reservation Note'
      end
      body do 
        p { long_form(@reservation) }
        detextilized @reservation.note
        form(:method => "POST",
             :action => Href.note_editing_page(@reservation)) do
          textarea(:name => "note",
                   :rows => "20",
                   :cols => "60") do
            rawtext @reservation.note
          end
          p do 
            text "You can add bolding and other effects using "
            a(:href => "http://redcloth.org/textile/phrase-modifiers/") do
              text "Textile"
            end
            text "."
          end
          p do 
            input(:type => 'submit', :value=>"Update Note")
          end
        end
      end
    end
  end
end

