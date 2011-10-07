class Controller
  get '/2' do
    redirect '/2.html'
  end

  get '/2/reservation/:reservation_id/note' do
    view(ReservationNoteView).new(:reservation_id => params[:reservation_id]).to_pretty
  end
end

