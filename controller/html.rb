class Controller
  attr_accessor :test_view_builder
  def view(klass); test_view_builder || klass; end

  get '/' do
    redirect '/index.html'
  end


  get '/hi' do
    'hi'
  end

  get '/reservation/:number' do
    number = params[:number]
    ReservationView.new(:reservation => reservation_source[number]).to_pretty
  end

  delete '/reservation/:number' do
    number = params[:number].to_i
    reservation_source.erase(number)
    tuple_publisher.remove_reservation_exclusions(number)
    redirect '/reservations'
  end

  get '/reservations' do 
    puts "To stdout"
    $stderr.puts "To stderr"
    CritterLogger.warn "To critterlogger"
    # reservations = reservation_source.eager(:groups => {:uses => [:animal, :procedure]}).all
    # view(ReservationListView).new(:reservations => reservations).to_s
    'hi: #{params.inspect}'
  end

  get '/animals' do 
    view(AnimalListView).new(:animal_source => animal_source,
                             :date_source => DateSource.new).to_s
  end

  delete '/animal/:number' do
    number = params[:number]
    effective_date = params[:as_of]
    animal_source[number].remove_from_service_as_of(effective_date)
    redirect '/animals'
  end

  get '/animals_with_pending_reservations' do
    view(AnimalsWithPendingReservationsView).new(:animal_source => Animal,
                                                 :date => Date.parse(params[:date])).to_s
  end
end

