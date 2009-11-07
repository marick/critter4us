require 'rubygems'
require 'sinatra/base'
require 'json'
require 'util/test-support'
require 'model/requires'
require 'view/requires'
require 'pp'

require 'erector'
include Erector::Mixin


class Controller < Sinatra::Base  # Todo: how can you have multiple controllers?
  include TestSupport

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

  def initialize(*args)
    super
    collaborators_start_as(:animal_source => Animal, 
                           :procedure_source => Procedure,
                           :reservation_source => Reservation,
                           :timeslice => Timeslice.new,
                           :hash_maker => HashMaker.new)
  end


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
    unless request.path =~ %r{/reservation/\d+} # generalize?
      protected! 
    end
  end


  get '/' do
    redirect '/index.html'
  end

  get '/json/course_session_data_blob' do
    internal = move_to_internal_format(params)
    timeslice.move_to(internal[:date], internal[:day_segment], ignored_reservation)
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

  def ignored_reservation
    ignoring = params[:ignoring]
    return nil unless ignoring
    Reservation[ignoring.to_i]
  end

  def exclusions(procedure_names)  # TODO: Why bother with hash_maker?
    excluded_pairs = []
    timeslice.add_excluded_pairs(excluded_pairs)
    hash_maker.keys_and_pairs(procedure_names, excluded_pairs)
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
    ReservationView.new(:reservation => reservation_source[number]).to_pretty
  end

  get '/json/reservation/:number' do
    number = params[:number]
    jsonically do 
      reservation = reservation_source[number]
      timeslice.move_to(reservation.date, reservation.day_segment, ignored_reservation)
      procedure_names = procedure_source.sorted_names
      reservation_data = {
        :instructor => reservation.instructor,
        :course => reservation.course,
        :date => reservation.date.to_s,
        :day_segment => reservation.day_segment,
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

  delete '/reservation/:number' do
    number = params[:number]
    reservation_source[number].destroy
    redirect '/reservations'
  end

  get '/reservations' do 
    view(ReservationListView).new(:reservations => reservation_source.all).to_s
  end

  def move_to_internal_format(hash)
    result = symbol_keys(hash)
    result[:date] = Date.parse(result[:date]) if result[:date]
    if result[:groups]
      result[:groups] = result[:groups].collect { | group | 
        symbol_keys(group)
      }
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

end
