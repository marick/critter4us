require 'rubygems'
require 'sinatra/base'
require 'json'


class Controller < Sinatra::Base

  attr_writer :persistent_store

  def initialize(settings = {})
    super()
    @persistent_store = settings[:persistent_store] || PersistentStore.new
  end
    

  get '/json/procedures' do
    response['Content-Type'] = 'application/json'
    list = @persistent_store.procedure_names
    {'procedures' => list.sort}.to_json
  end
end
