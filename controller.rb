require 'rubygems'
require 'sinatra/base'
require 'json'
require 'util/test-support'
require 'model/requires'
require 'view/requires'
require 'pp'

require 'erector'
include Erector::Mixin

# TODO: This is in root directory so that public is set right without
# my having to do anything. Should probably migrate into subdirectory.

# TODO: It might be a better idea to have a json controller and an
# html controller instead of using includes with one controller.

class Controller < Sinatra::Base  
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

  before do
    unless request.path =~ %r{/reservation/\d+} # generalize?
      protected! 
    end
  end

  def initialize(*args)
    super
    collaborators_start_as(:animal_source => Animal, 
                           :procedure_source => Procedure,
                           :reservation_source => Reservation,
                           :timeslice => Timeslice.new,
                           :hash_maker => HashMaker.new)
  end
end

require 'controller/authorization'
require 'controller/html'
require 'controller/json'
