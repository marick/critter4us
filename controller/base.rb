require 'rubygems'
require 'sinatra/base'
require 'json'
require './util/test-support'
require './model/requires'
require './view/requires'
require './views/requires'
require 'pp'

require 'erector'
include Erector::Mixin

# TODO: It might be a better idea to have a json controller and an
# html controller instead of using includes with one controller.

class Controller < Sinatra::Base  
  include TestSupport

  # In Rack::Test tests, it's hard to grab hold of the actual controller
  # from behind a maze of middleware. (It seems.) So this is a hack to make
  # it available to tests so that mocks can be injected.
  class << self
    attr_accessor :actual_object
  end

  set :static, true
  set :root, File.join(File.dirname(__FILE__), "..")
  enable :raise_errors
  enable :sessions
  enable :methodoverride

  before do
    CritterLogger.info "==== #{request.path}"

    unless request.path =~ %r{/reservation/\d+} # generalize?
      protected! 
    end
  end

  def initialize(*args)
    super
    self.class.actual_object = self
    collaborators_start_as(:animal_source => Animal, 
                           :procedure_source => Procedure,
                           :reservation_source => Reservation,
                           :internalizer => Internalizer.new,
                           :externalizer => Externalizer.new,
                           :availability_source => Availability,
                           :tuple_publisher => TuplePublisher.new,
                           :date_source => Date,
                           :renderer => Renderer.new
                           )
  end
end

require './controller/internalizer'
require './controller/externalizer'
require './controller/authorization'
require './controller/html'
require './controller/json'
require './controller/2'
