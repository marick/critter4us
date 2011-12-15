# -*- indent-tabs-mode: nil -*-

require './src/routes/base'
require './src/views/requires'

class Controller

  def desired_reservation
    reservation_id = params[:reservation_id]
    reservation_source[reservation_id]
  end

  get Href::Reservation.note_editor_match do 
    @renderer.render_page(:reservation__note_editor, 
                          :reservation => desired_reservation)
  end

  get Href::Reservation.repetition_adder_match do
    @renderer.render_page(:reservation__repetition_adder,
                          :reservation => desired_reservation)
  end
end

