require 'rubygems'
require 'sinatra/base'
require 'json'
require 'util/test-support'
require 'model/requires'
require 'view/requires'
require 'pp'

require 'erector'
include Erector::Mixin

# TODO: It might be a better idea to have a json controller and an
# html controller instead of using includes with one controller.

class Controller < Sinatra::Base  
  include TestSupport

  set :static, true
  set :root, File.join(File.dirname(__FILE__), "..")
  enable :raise_errors
  enable :sessions

  # TODO: Not wild about this. If methodoverride is enabled in the 
  # test environment, Controller.new returns this:
  #<Rack::MethodOverride:0x19fbe50 @app=#<Controller:0x19fbf7c @app=nil>>
  # so test calls like 
  #    Controller.new.authorizer = ... 
  # die with method-not-found.
  enable :methodoverride unless environment == :test

  before do
    CritterLogger.info "==== #{request.path}"

    unless request.path =~ %r{/reservation/\d+} # generalize?
      protected! 
    end
  end

  attr_writer :mock_timeslice
  attr_writer :mock_excluder
  attr_accessor :timeslice
  attr_accessor :excluder

  def initialize(*args)
    super
    collaborators_start_as(:animal_source => Animal, 
                           :procedure_source => Procedure,
                           :reservation_source => Reservation)
    self
  end
end

require 'controller/internalizer'
require 'controller/externalizer'
require 'controller/authorization'
require 'controller/html'
require 'controller/json'
