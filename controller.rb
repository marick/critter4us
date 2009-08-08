require 'rubygems'
require 'sinatra/base'
require 'json'
require 'model'


class Controller < Sinatra::Base

  set :static, true
  set :root, File.dirname(__FILE__)

  get '/' do
    File.read(File.join(options.public, 'index.html'))
  end

  get '/json/procedures' do
    jsonically do 
      typing_as 'procedures' do
        Procedure.names.sort
      end
    end
  end

  get '/json/all_animals' do
    jsonically do 
      typing_as 'animals' do
        Animal.names.sort
      end
    end
  end

  get '/json/exclusions' do
    jsonically do
      typing_as 'exclusions' do
        date = Date.parse(params['date'])
        ExclusionMap.new(date).to_hash
      end
    end
  end

  post '/json/store_reservation' do
    data = params['data']
    hash = JSON.parse(data)
    Reservation.create_with_uses(hash['date'],
                                 hash['procedures'],
                                 hash['animals'])
    "hello, world"
  end

  private

  def jsonically
    response['Content-Type'] = 'application/json'
    yield.to_json
  end

  def typing_as(type)
    {type.to_s => yield }
  end
    

end
