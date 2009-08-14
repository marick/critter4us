require 'rubygems'
require 'sinatra/base'
require 'json'
require 'model'
require 'view'
require 'pp'

require 'erector'
include Erector::Mixin

class Controller < Sinatra::Base

  set :static, true
  set :root, File.dirname(__FILE__)
  enable :raise_errors

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
        animals = Animal.all.sort { | a, b | a.name <=> b.name }
        names = animals.collect { | a | a.name }
        map = {}
        animals.each { | a | map[a.name] = a.kind }
        [names, map]
      end
    end
  end

  get '/json/exclusions' do
    jsonically do
      typing_as 'exclusions' do
        internal = move_to_internal_format(params)
        ExclusionMap.new(internal[:date], internal[:morning]).to_hash
      end
    end
  end

  post '/json/store_reservation' do
    hash = move_to_internal_format(JSON.parse(params['data']))
    reservation = Reservation.create_with_uses(hash)
    jsonically do
      typing_as "reservation" do 
        reservation.id.to_s
      end
    end
  end

  get '/reservation/:number' do
    number = params[:number]
    ReservationView.new(:reservation => Reservation[number]).to_s
  end

  def move_to_internal_format(hash)
    result = {}
    hash.each { | k, v | result[k.to_sym] = v }


    result[:date] = Date.parse(result[:date]) if result[:date]
    if result[:time]
      result[:morning] = (result[:time]=="morning")
      result.delete(:time)
    end
    result
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
