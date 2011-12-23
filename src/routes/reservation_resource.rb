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

  put Href::Reservation.repetitions_match do |reservation_id|
    json_response
    reservation = FullReservation.from_id(reservation_id)
    old_timeslice = FunctionalTimeslice.from_reservation(reservation)
    new_timeslice = old_timeslice.shift_by_days(params[:day_shift].to_i)
    @renderer.render_json(Functionally.copy_to_timeslice(reservation, new_timeslice)) 
  end
end

