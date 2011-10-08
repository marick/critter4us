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
        detextilized(@reservation.note)
        form(:method => "POST",
             :action => note_view_uri(@reservation)) do
          textarea(:name => "note",
                   :rows => "20",
                   :cols => "60") do
            rawtext @reservation.note
          end
          p do 
            input(:type => 'submit', :value=>"Update Note")
          end
        end
      end
    end
  end
end

