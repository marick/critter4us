# -*- indent-tabs-mode: nil -*-

require './src/routes/base'
require './src/views/requires'

class Controller

  def desired_reservation
    reservation_id = params[:reservation_id]
    reservation_source[reservation_id]
  end

  def render_reservation_page(page_id)
    @renderer.render_page(page_id, :reservation => desired_reservation)
  end
    

  get Href::Task_Uis.edit_reservation_note_match do 
    render_reservation_page(:task_uis__reservation__edit_note)
  end

  get Href::Task_Uis.make_reservation_copies_match do 
    render_reservation_page(:task_uis__reservation__make_copies)
  end
end

