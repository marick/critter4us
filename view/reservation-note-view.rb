require './view/util'

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
        form(:method => "POST",
             :action => "/2/reservation/#{@reservation.id}/note") do
          textarea(:name => "note") do
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

