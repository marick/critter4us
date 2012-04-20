class Controller
  attr_accessor :test_view_builder
  def view(klass); test_view_builder || klass; end

  get '/' do
    redirect '/index.html'
  end

  get '/protected_route_for_testing' do 
    'hi'
  end

  get '/reservation/:number' do
    number = params[:number]
    ReservationView.new(:reservation => reservation_source[number]).to_pretty
  end

  delete '/reservation/:number/:days_to_display_after_deletion' do
    number = params[:number].to_i
    reservation_source.erase(number)
    tuple_publisher.remove_reservation_exclusions(number)
    redirect "/reservations/#{params[:days_to_display_after_deletion]}"
  end

  get '/animals' do 
    view(AnimalListView).new(:animal_source => animal_source,
                             :date_source => DateSource.new).to_html
  end

  delete '/animal/:number' do
    number = params[:number]
    effective_date = params[:as_of]
    animal_source[number].remove_from_service_as_of(effective_date)
    redirect '/animals'
  end

  get '/animals_with_pending_reservations' do
    view(AnimalsWithPendingReservationsView).new(:animal_source => Animal,
                                                 :date => Date.parse(params[:date])).to_html
  end

  get '/animal_usage_report' do
    timeslice = @internalizer.make_timeslice_from_dates(params['firstDate'],
                                                       params['lastDate'])
    availability = @availability_source.new(timeslice)
    view(UsesOfManyAnimalsView).new(:data => availability.animal_usage,
                                    :timeslice => timeslice).to_html
  end
end

