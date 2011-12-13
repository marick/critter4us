# -*- indent-tabs-mode: nil -*-

require './src/routes/base'
require './src/views/requires'
require './src/db/full_reservation'

class Controller
  put Href::Reservation.note_match do | reservation_id | 
    reservation = reservation_source[reservation_id]
    reservation.update(:note => params[:note])
    @renderer.render_textile(reservation.note)
  end

  post Href::Reservation.repetitions_match do |reservation_id|
    json_response
    puts reservation_id.inspect
    puts params.inspect
    @renderer.render_json({:blah => ["1", "2", "3"]})
    # reservation = FullReservation.from_id(reservation_id)
    # timeslice = FunctionalTimeslice.from_browser(params[:timeslice])
    # @renderer.render_json(Functionally.copy_to_timeslice(reservation, timeslice)) 
  end
end

