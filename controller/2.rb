require './views/requires'

class Controller
  set :haml, :format => :html5
  helpers Sinatra::Partials, Helpers::Reservation

  get '/2' do
    redirect '/2.html'
  end

  get Href.note_editing_page_route(:reservation_id) do |reservation_id|
    @renderer.render_page(:get_note_editing_page, :reservation => reservation_source[reservation_id])
  end

  post Href.note_editing_page_route(:reservation_id) do
    reservation = reservation_source[params[:reservation_id]]
    reservation.update(:note => params[:note])
    textile_note(reservation)
  end


end

