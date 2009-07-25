require 'rubygems'
require 'config'
require 'persistent-store'
require 'controller'

Controller.run! :host => 'localhost', :port => 7000
