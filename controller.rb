require 'rubygems'
require 'sinatra/base'
require 'json'
require 'model/requires'
require 'view/requires'
require 'pp'

require 'erector'
include Erector::Mixin


class Controller < Sinatra::Base  # Todo: how can you have multiple controllers?

  set :static, true
  set :root, File.dirname(__FILE__)
  enable :raise_errors
  enable :sessions

  # TODO: Not wild about this. If methodoverride is enabled in the 
  # test environment, Controller.new returns this:
  #<Rack::MethodOverride:0x19fbe50 @app=#<Controller:0x19fbf7c @app=nil>>
  # so test calls like 
  #    Controller.new.authorizer = ... 
  # die with method-not-found.
  enable :methodoverride unless environment == :test

  attr_accessor :test_view_builder
  attr_writer :authorizer

  helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="critter4us")
        throw(:halt, [401, "Not authorized\n"])
        return
      end
    end

    def authorized?
      auth_request = Rack::Auth::Basic::Request.new(request.env)
      authorizer.already_authorized? || authorizer.authorize(auth_request)
    end
  end

  before do
    protected!
  end


  get '/' do
    File.read(File.join(options.public, 'index.html'))
  end

  get '/json/course_session_data_blob' do
    internal = move_to_internal_format(params)
    jsonically do 
      retval = {
        'animals' => Animal.names.sort,
        'procedures' => Procedure.names.sort,
        'kindMap' => Animal.kind_map,
        'exclusions' => ExclusionMap.new(internal[:date],
                                         internal[:morning]).to_hash
      }
      # pp retval
      retval
    end
  end

  post '/json/store_reservation' do
    tweak_reservation do | hash | 
      Reservation.create_with_groups(hash)
    end
  end

  post '/json/modify_reservation' do
    id = params['reservationID'].to_i;
    tweak_reservation do | hash | 
      Reservation[id].with_updated_groups(hash)
    end
  end

  def tweak_reservation
    hash = move_to_internal_format(JSON.parse(params['data']))
    reservation = yield hash
    jsonically do
      typing_as "reservation" do 
        reservation.pk.to_s
      end
    end
  end

  get '/reservation/:number' do
    number = params[:number]
    ReservationView.new(:reservation => Reservation[number]).to_pretty
  end

  get '/json/reservation/:number' do
    number = params[:number]
    jsonically do 
      reservation = Reservation[number]
      reservation_data = {
        :instructor => reservation.instructor,
        :course => reservation.course,
        :date => reservation.date.to_s,
        :morning => reservation.morning,
        :groups => reservation.groups.collect { | g | g.in_wire_format },
        :procedures => Procedure.names,
        :animals => Animal.names,
        :kindMap => kind_map(),
        :exclusions => ExclusionMap.new(reservation.date,
                                        reservation.morning).
                                    allowing(reservation.animal_names).
                                    to_hash,
        :id => reservation.pk.to_s
      }
    end
  end

  delete '/reservation/:number' do
    number = params[:number]
    Reservation[number].destroy
    redirect '/reservations'
  end

  get '/reservations' do 
    view(ReservationListView).new(:reservations => Reservation.all).to_s
  end

  def move_to_internal_format(hash)
    result = symbol_keys(hash)
    result[:date] = Date.parse(result[:date]) if result[:date]
    if result[:groups]
      result[:groups] = result[:groups].collect { | group | 
        symbol_keys(group)
      }
    end
    if result[:time]
      result[:morning] = (result[:time]=="morning")
      result.delete(:time)
    end
    result
  end

  def symbol_keys(hash)
    retval = {}
    hash.each do | k, v | 
      retval[k.to_sym] = v
    end
    return retval
  end

  private

  def view(klass)
    (test_view_builder || klass)
  end

  def authorizer
    @authorizer ||= Authorizer.new(session)
    @authorizer
  end

  def jsonically
    response['Content-Type'] = 'application/json'
    yield.to_json
  end

  def typing_as(type)
    {type.to_s => yield }
  end

  def kind_map
    map = {}
    Animal.all.each { | a | map[a.name] = a.kind }
    map
  end
    
end
