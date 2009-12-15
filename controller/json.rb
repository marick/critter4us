require 'util/extensions'
require 'model/excluders/excluder.rb'


class Controller

  before do
    if request.path =~ %r{/json/}
      response['Content-Type'] = 'application/json'
    end

    @timeslice = @mock_timeslice || Timeslice.new
    @excluder = @mock_excluder || Excluder.new(@timeslice)
  end

  get '/json/course_session_data_blob' do
    internal = internalize(params)
    timeslice.move_to(internal[:date], internal[:time], ignored_reservation)
    externalize(:animals => timeslice.animals_that_can_be_reserved,
                :procedures => timeslice.procedures,
                :kindMap => animal_source.kind_map,
                :timeSensitiveExclusions => excluder.time_sensitive_exclusions,
                :timelessExclusions => excluder.timeless_exclusions)
  end

  post '/json/store_reservation' do
    reservation_data = internalize(params)[:data]
    new_reservation = reservation_source.create_with_groups(reservation_data)
    externalize(reservation_hash(new_reservation))
  end

  post '/json/modify_reservation' do
    internal = internalize(params)
    id = internal[:reservationID]
    reservation_data = internal[:data]
    updated_reservation = reservation_source[id].with_updated_groups(reservation_data)
    externalize(reservation_hash(updated_reservation))
  end

  def reservation_hash(reservation) 
    {"reservation" => reservation.pk.to_s}
  end

  post '/json/take_animals_out_of_service' do
    internal = internalize(params)[:data]
    internal[:animals].each do | animal_name |
      Animal[:name => animal_name].remove_from_service_as_of(internal[:date])
    end
  end

  get '/json/reservation/:number' do
    number = params[:number]
    reservation = reservation_source[number]
    timeslice.move_to(reservation.date, reservation.time, ignored_reservation)
    externalize(:instructor => reservation.instructor,
                :course => reservation.course,
                :date => reservation.date,
                :time => reservation.time,
                :groups => reservation.groups,
                :procedures => timeslice.procedures,
                :animals => timeslice.animals_that_can_be_reserved,
                :kindMap => animal_source.kind_map,
                :timeSensitiveExclusions => excluder.time_sensitive_exclusions,
                :timelessExclusions => excluder.timeless_exclusions,
                :id => reservation.pk.to_s)
  end

  get '/json/animals_in_service_blob' do  # TODO: I think this name needs to be changed.
    internal = internalize(params)
    timeslice.move_to(internal[:date], MORNING, nil)
    animals = timeslice.animals_that_can_be_reserved
    hashes = timeslice.hashes_from_animals_to_pending_dates(animals)
    animals_without_uses = filter_unused_animals(hashes)
    externalize('unused animals' => animals_without_uses)
  end

  private

  def internalize(hash)
    Internalizer.new.convert(hash)
  end

  def externalize(hash)
    Externalizer.new.convert(hash)
  end

  def ignored_reservation
    ignoring = params[:ignoring]
    return nil unless ignoring
    Reservation[ignoring.to_i]
  end

  def filter_unused_animals(hashes)
    hashes.find_all { | hash |
      hash.only_value.empty?
    }.collect { | hash | 
      hash.only_key
    }.sort
  end
end
