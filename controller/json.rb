require 'json'

class JsonController < Ramaze::Controller
  # the index action is called automatically when no other action is specified
  def index
    { 'error' => 'API error.' }.to_json 
  end

  def cows
    response[ 'Content-Type' ] = 'application/json' 
    if request.get? 
      names = DB[:animals].collect { | row | row[:name] }
      x = { 'cows' => names }.to_json 
      puts "Sending back #{x.inspect}"
      x
    else 
      { 'error' => 'API error.' }.to_json 
    end 
  end 

end
