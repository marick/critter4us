require 'rubygems'
require File.expand_path('path-setting', File.dirname(__FILE__))

require 'config'
require 'persistent-store'
require 'controller'

Controller.run! :host => 'localhost', :port => 7000
