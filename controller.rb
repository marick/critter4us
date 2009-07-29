require 'rubygems'
require 'sinatra/base'
require 'json'


class Controller < Sinatra::Base

  set :static, true
  set :root, File.dirname(__FILE__)

  attr_writer :persistent_store

  def initialize(settings = {})
    super()
    @persistent_store = settings[:persistent_store] || PersistentStore.new
  end


  get '/' do
    File.read(File.join(options.public, 'index.html'))
  end

  get '/json/procedures' do
    jsonically do 
      typing_as 'procedures' do
        @persistent_store.procedure_names.sort
      end
    end
  end

  get '/json/all_animals' do
    jsonically do 
      typing_as 'animals' do 
        @persistent_store.all_animals.sort
      end
    end
  end

  get '/json/exclusions' do
    jsonically do
      typing_as 'exclusions' do
        date = Date.parse(params['date'])
        @persistent_store.exclusions_for_date(date)
      end
    end
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
