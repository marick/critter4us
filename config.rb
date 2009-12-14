require 'sinatra/base'
require 'sequel'
require 'logger'

CritterLogger = Logger.new($stdout)

Sinatra::Base.configure :test do 
DB = Sequel.postgres("critter4us-test", :host => 'localhost', :user => 'postgres')
CritterLogger.level = Logger::WARN
end

Sinatra::Base.configure :development do 
  DB = Sequel.postgres("critter4us", :host => 'localhost', :user => 'postgres', :loggers => [Logger.new($stdout)])
  CritterLogger.level = Logger::INFO
end

Sinatra::Base.configure :production do 
  DB = Sequel.connect(ENV['DATABASE_URL'])
  CritterLogger.level = Logger::WARN
end

