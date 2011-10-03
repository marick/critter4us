require 'rubygems'

require './config'
require './controller/base'
require './view/requires'

Sinatra::Base.configure :development do
  Controller.run! :host => 'localhost', :port => 7000
end

