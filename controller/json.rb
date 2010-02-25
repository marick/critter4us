require 'util/extensions'
require 'model/excluders/excluder.rb'


class Controller

  before do
    if request.path =~ %r{/json/}
      response['Content-Type'] = 'application/json'
    end
  end

  get '/json/animals_and_procedures_blob' do
    reservation_to_ignore = @internalizer.find_reservation(params, 'ignoring')
    timeslice = @internalizer.make_timeslice(params['timeslice'], reservation_to_ignore)
    externalize(:animals => timeslice.animals_that_can_be_reserved,
                :procedures => timeslice.procedures,
                :kindMap => animal_source.kind_map,
                :timeSensitiveExclusions => excluder.time_sensitive_exclusions(timeslice),
                :timelessExclusions => excluder.timeless_exclusions(timeslice))
  end

  post '/json/store_reservation' do
    reservation_data = @internalizer.convert(params)[:data]
    new_reservation = reservation_source.create_with_groups(reservation_data)
    externalize(reservation_hash(new_reservation))
  end

  post '/json/modify_reservation' do
    internal = @internalizer.convert(params)
    id = internal[:reservationID]
    reservation_data = internal[:data]
    updated_reservation = reservation_source[id].with_updated_groups(reservation_data)
    externalize(reservation_hash(updated_reservation))
  end

  def reservation_hash(reservation) 
    {"reservation" => reservation.pk.to_s}
  end

  post '/json/take_animals_out_of_service' do
    internal = @internalizer.convert(params)[:data]
    internal[:animals].each do | animal_name |
      Animal[:name => animal_name].remove_from_service_as_of(internal[:date])
    end
  end

  get '/json/reservation/:number' do
    reservation_to_fetch = @internalizer.find_reservation(params, 'number')
    reservation_to_ignore = @internalizer.find_reservation(params, 'ignoring')
    timeslice = reservation_to_fetch.timeslice(reservation_to_ignore)
    externalize(:instructor => reservation_to_fetch.instructor,
                :course => reservation_to_fetch.course,
                :firstDate => reservation_to_fetch.first_date,
                :lastDate => reservation_to_fetch.last_date,
                :times => reservation_to_fetch.times,
                :groups => reservation_to_fetch.groups,
                :procedures => timeslice.procedures,
                :animals => timeslice.animals_that_can_be_reserved,
                :kindMap => animal_source.kind_map,
                :timeSensitiveExclusions => excluder.time_sensitive_exclusions(timeslice),
                :timelessExclusions => excluder.timeless_exclusions(timeslice),
                :id => reservation_to_fetch.pk.to_s)
  end

  get '/json/animals_that_can_be_taken_out_of_service' do
    # Note: this params list contains a single date, not full timeslice data
    timeslice = @internalizer.make_timeslice_from_date(params['date'])
    animals = timeslice.animals_that_can_be_reserved
    hashes = timeslice.hashes_from_animals_to_pending_dates(animals)
    animals_without_uses = filter_unused_animals(hashes)
    externalize('unused animals' => animals_without_uses)
  end

  private

  def externalize(hash)
    Externalizer.new.convert(hash)
  end

  def filter_unused_animals(hashes)
    hashes.find_all { | hash |
      hash.only_value.empty?
    }.collect { | hash | 
      hash.only_key
    }.sort
  end
end
