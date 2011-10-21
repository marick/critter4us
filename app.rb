require 'rubygems'

require './config'
require './strangled-src/view/requires'

require './src/routes/base'
require './src/views/requires'
require './src/functional/functionally'
require './src/routes/requires'

Sinatra::Base.configure :development do
  Controller.run! :host => 'localhost', :port => 7000
end

