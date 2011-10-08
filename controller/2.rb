class Controller
  get '/2' do
    redirect '/2.html'
  end

  get '/2/reservation/:reservation_id/note' do
    number = params[:reservation_id].to_i
    view(ReservationNoteView).new(:reservation => reservation_source[number]).to_pretty
  end

  post '/2/reservation/:reservation_id/note' do
    number = params[:reservation_id].to_i
    reservation_source[number].update(:note => params[:note])
    redirect "/2/reservation/#{number}/note"
  end
end

