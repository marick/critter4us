class Controller
  get '/2' do
    redirect '/2.html'
  end

  get Href.note_editing_page_route(:reservation_id) do
    number = params[:reservation_id]
    view(ReservationNoteView).new(:reservation => reservation_source[number]).to_pretty
  end

  post Href.note_editing_page_route(:reservation_id) do
    reservation = reservation_source[params[:reservation_id]]
    reservation.update(:note => params[:note])
    redirect Href.note_editing_page(reservation)
  end
end

