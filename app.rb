require 'rubygems'
require File.expand_path('path-setting', File.dirname(__FILE__))

require 'config'
require 'controller'

Sinatra::Base.configure :development do
  Controller.run! :host => 'localhost', :port => 7000
end

Sinatra::Base.configure :production do 
  require 'hello'
  run Sinatra::Application
end
