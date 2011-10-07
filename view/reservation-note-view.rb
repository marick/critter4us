require './view/util'

class ReservationNoteView < Erector::Widget     
  include ViewHelper

  def content
    html do 
      head do
        title 'Reservation Note'
      end
    end
  end
end

