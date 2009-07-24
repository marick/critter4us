require 'json'

class JsonController < Ramaze::Controller
  # the index action is called automatically when no other action is specified
  def index
    { 'error' => 'API error.' }.to_json 
  end

  def procedures
    response[ 'Content-Type' ] = 'application/json' 
    if request.get? 
      list = DB[:procedures].map(:name)
      {'procedures' => list}.to_json
    else 
      { 'error' => 'API error.' }.to_json 
    end
  end

  def all_animals
    response[ 'Content-Type' ] = 'application/json' 
    if request.get? 
      list = DB[:animals].map(:name)
      {'animals' => list}.to_json
    else 
      { 'error' => 'API error.' }.to_json 
    end
  end

  def selected_animals
    response[ 'Content-Type' ] = 'application/json' 
    if request.get? 
      procedure_name = request[:procedure]

      procedure_id = DB[:procedures].filter(:name => procedure_name).map(:id)[0]

      query = DB[:uses].filter(:procedure_id => procedure_id,
                               :date => (Date.new(1969)..(Date.new(2009, 7, 23)-14)))

      animal_ids = query.map(:animal_id)
      list = animal_ids.collect { | id | DB[:animals][:id => id][:name] }
      puts list.inspect
      {'animals' => list}.to_json
    else 
      { 'error' => 'API error.' }.to_json 
    end
  end

end
