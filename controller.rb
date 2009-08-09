require 'rubygems'
require 'sinatra/base'
require 'json'
require 'model'
require 'view'


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
    reservation = Reservation.create_with_uses(hash['date'],
                                               hash['procedures'],
                                               hash['animals'])
    jsonically do
      typing_as "reservation" do 
        reservation.id.to_s
      end
    end
  end

  get '/reservation/:number' do
    number = params[:number]
    ReservationDescription.new(:reservation => Reservation[number]).to_s
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
