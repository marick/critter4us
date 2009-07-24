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
end
