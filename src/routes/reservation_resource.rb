# -*- indent-tabs-mode: nil -*-

require './src/routes/base'
require './src/views/requires'

class Controller
  put Href::Reservation.note_match do | reservation_id | 
    reservation = reservation_source[reservation_id]
    reservation.update(:note => params[:note])
    @renderer.render_textile(reservation.note)
  end

  # TODO: Temp name
  post Href::Reservation.schedule_reservations_page_match do |reservation_id|
    json_response
    reservation = FullReservation.from_id(reservation_id)
    timeslice = FunctionalTimeslice.from_browser(params[:timeslice])
    @renderer.render_json(Functionally.copy_to_timeslice(reservation, timeslice))
  end
end

