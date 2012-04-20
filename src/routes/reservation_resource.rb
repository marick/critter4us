# -*- indent-tabs-mode: nil -*-

require './src/routes/base'
require './src/views/requires'
require './src/shapes/requires'
require './src/db/full_reservation'
require './src/db/database_structure'

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

  get Href::Reservation.list_match do
    days_shown = @internalizer2.days_in_the_past(params[:days])
    rows = @reservation_table.rows_back_to(@date_source.today - days_shown)
    sorted_rows = rows.become(TimeslicedElementShaped).in_descending_date_order
    render_reservation_list_view(sorted_rows, days_shown)
  end

  def render_reservation_list_view(rows, days)
    view(NewReservationListView).
      new(:reservations => rows,
          :days_to_display_after_deletion => days).
      to_html
  end
end

