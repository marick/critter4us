require 'util/extensions.rb'

class Controller

  get '/json/course_session_data_blob' do
    internal = internalize(params)
    timeslice.move_to(internal[:date], internal[:time], ignored_reservation)
    procedure_names = procedure_source.sorted_names
    jsonically do 
      answer = {
        'animals' => timeslice.available_animals_by_name,
        'procedures' => procedure_names,
        'kindMap' => animal_source.kind_map,
        'exclusions' => self.exclusions(procedure_names)
        
      }
      answer
    end
  end

  post '/json/store_reservation' do
    tweak_reservation do | hash | 
      reservation_source.create_with_groups(hash)
    end
  end

  post '/json/modify_reservation' do
    id = params['reservationID'].to_i;
    tweak_reservation do | hash | 
      reservation_source[id].with_updated_groups(hash)
    end
  end

  post '/json/take_animals_out_of_service' do
    internal = internalize(JSON.parse(params['data']))
    internal[:animals].each do | animal_name |
      Animal[:name => animal_name].remove_from_service_as_of(internal[:date])
    end
  end

  get '/json/reservation/:number' do
    number = params[:number]
    jsonically do 
      reservation = reservation_source[number]
      timeslice.move_to(reservation.date, reservation.time, ignored_reservation)
      procedure_names = procedure_source.sorted_names
      reservation_data = {
        :instructor => reservation.instructor,
        :course => reservation.course,
        :date => reservation.date.to_s,
        :time => reservation.time,
        :groups => reservation.groups.collect { | g | g.in_wire_format },
        :procedures => procedure_names,
        :animals => timeslice.available_animals_by_name,
        :kindMap => animal_source.kind_map,
        :exclusions => self.exclusions(procedure_names),
        :id => reservation.pk.to_s
      }
      # pp reservation_data
    end
  end

  get '/json/animals_in_service_blob' do
    internal = internalize(params)
    timeslice.move_to(internal[:date], MORNING, nil)
    animals = timeslice.available_animals
    hashes = timeslice.hashes_from_animals_to_pending_dates(animals)
    jsonically do 
      animals_without_uses = filter_unused_animal_names(hashes)
      {'unused animals' => animals_without_uses}
    end
  end



  # tested

  def exclusions(procedure_names)  # TODO: Why bother with hash_maker?
    excluded_pairs = []
    timeslice.add_excluded_pairs(excluded_pairs)
    hash_maker.keys_and_pairs(procedure_names, excluded_pairs)
  end

  private

  def internalize(hash)
    Internalizer.new.convert(hash)
  end

  def tweak_reservation
    hash = internalize(JSON.parse(params['data']))
    reservation = yield hash
    jsonically do
      typing_as "reservation" do 
        reservation.pk.to_s
      end
    end
  end

  def jsonically
    response['Content-Type'] = 'application/json'
    yield.to_json
  end

  def typing_as(type)
    {type.to_s => yield }
  end

  def ignored_reservation
    ignoring = params[:ignoring]
    return nil unless ignoring
    Reservation[ignoring.to_i]
  end

  def filter_unused_animal_names(hashes)
    hashes.find_all { | hash |
      hash.only_value.empty?
    }.collect { | hash | 
      hash.only_key.name
    }.sort
  end


end
