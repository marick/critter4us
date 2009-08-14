require 'sinatra/base'

class Controller < Sinatra::Base
  get '/' do
    "hello"
  end
end
