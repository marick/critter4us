# -*- indent-tabs-mode: nil -*-

require './src/routes/base'
require './src/views/requires'

class Controller
  set :haml, :format => :html5
  helpers Sinatra::Partials, Helpers::Reservation

  get '/2' do
    redirect '/2.html'
  end

  get Href.note_editing_page_route(:reservation_id) do |reservation_id|
    reservation = reservation_source[reservation_id]
    @renderer.render_page(:get_note_editing_page, :reservation => reservation)
  end

  post Href.note_editing_page_route(:reservation_id) do
    reservation = reservation_source[params[:reservation_id]]
    reservation.update(:note => params[:note])
    @renderer.render_textile(reservation.note)
  end


  get Href.schedule_reservations_page_route(:reservation_id) do |reservation_id|
    reservation = reservation_source[reservation_id]
    @renderer.render_page(:get_reservation_scheduling_page, :reservation => reservation)
  end

  post Href.schedule_reservations_page_route(:reservation_id) do |reservation_id|
    json_response
    reservation = FullReservation.from_id(reservation_id)
    timeslice = FunctionalTimeslice.from_browser(params[:timeslice])
    @renderer.render_json(Functionally.copy_to_timeslice(reservation, timeslice))
  end
end

