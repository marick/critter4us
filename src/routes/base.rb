require 'rubygems'
require 'sinatra/base'
require 'json'
require 'pp'
require './strangled-src/util/test-support'
require './strangled-src/model/requires'
require './strangled-src/view/requires'


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
  set :root, File.join(File.dirname(__FILE__), "..", "..")
  set :views, File.join(File.dirname(__FILE__), "..", "views")
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

                           # The new, strangling code.
                           :renderer => Renderer.new,
                           :internalizer2 => Internalizer2.new(@internalizer),
                           :functionally => Functionally
                           )
  end
end

require './strangled-src/controller/internalizer'
require './strangled-src/controller/externalizer'
require './strangled-src/controller/authorization'
require './strangled-src/controller/html'
require './strangled-src/controller/json'

# New version - this only allowable upward call.
require './src/routes/requires'
require './src/functional/functionally'
