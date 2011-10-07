require './view/util'

class AddNoteView < Erector::Widget     
  include ViewHelper

  def content
    html do 
      head do
        title 'Reservation Note'
      end
    end
  end
end

