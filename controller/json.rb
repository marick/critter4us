require 'util/extensions'

class Controller

  before do
    if request.path =~ %r{/json/}
      response['Content-Type'] = 'application/json'
    end
  end

  get '/json/animals_and_procedures_blob' do
    availability = @availability_source.new(@internalizer.make_timeslice(params['timeslice']),
                                            @internalizer.integer_or_nil(params['ignoring']))

    externalize(availability.animals_and_procedures_and_exclusions)
  end

  post '/json/store_reservation' do
    reservation_data = @internalizer.convert(params)[:data]
    new_reservation = reservation_source.create_with_groups(reservation_data)
    @tuple_publisher.note_reservation_exclusions(new_reservation)
    externalize(reservation_id(new_reservation))
  end

  post '/json/modify_reservation' do
    internal = @internalizer.convert(params)
    id = internal[:reservationID]
    reservation_data = internal[:data]
    updated_reservation = reservation_source[id]
    updated_reservation.update_with_groups(reservation_data)
    @tuple_publisher.remove_reservation_exclusions(updated_reservation.id)
    @tuple_publisher.note_reservation_exclusions(updated_reservation)
    externalize(reservation_id(updated_reservation))
  end

  post '/json/take_animals_out_of_service' do
    internal = @internalizer.convert(params)[:data]
    internal[:animals].each do | animal_name |
      Animal[:name => animal_name].remove_from_service_as_of(internal[:date])
    end
  end

  get '/json/reservation/:number' do
    reservation_to_fetch = @internalizer.find_reservation(params, 'number')
    reservation_to_ignore = @internalizer.integer_or_nil(params['ignoring'])
    availability = @availability_source.new(reservation_to_fetch.timeslice,
                                            reservation_to_ignore)
    externalize(reservation_to_fetch.to_hash.merge(
                availability.animals_and_procedures_and_exclusions))
  end

  get '/json/animals_that_can_be_taken_out_of_service' do
    timeslice = @internalizer.make_timeslice_from_date(params['date'])
    availability = @availability_source.new(timeslice)
    animal_names = availability.animals_that_can_be_removed_from_service
    externalize('unused animals' => animal_names)
  end

  private

  def reservation_id(reservation) 
    {"reservation" => reservation.id.to_s}
  end

  def externalize(hash)
    @externalizer.convert(hash)
  end

  # TODO: MOVE
  def filter_unused_animals(hashes)
    hashes.find_all { | hash |
      hash.only_value.empty?
    }.collect { | hash | 
      hash.only_key
    }.sort
  end
end
