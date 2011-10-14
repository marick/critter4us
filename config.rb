require 'rubygems'
require 'sinatra/base'
require 'sequel'
require 'logger'

CritterLogger = Logger.new($stdout)

Sinatra::Base.configure :test do 
DB = Sequel.postgres("critter4us-test", :host => 'localhost',
                     :user => ENV['C4U_USER'],
                     :password => ENV['C4U_TEST_PASS'])
CritterLogger.level = Logger::WARN
end

Sinatra::Base.configure :development do 
  DB = Sequel.postgres("critter4us", :host => 'localhost',
                       :user => ENV['C4U_DEV_USER'],
                       :password => ENV['C4U_PASS'],
                       :loggers => [Logger.new($stdout)])
  CritterLogger.level = Logger::INFO
end

Sinatra::Base.configure :production do 
  DB = Sequel.connect(ENV['DATABASE_URL'])
  CritterLogger.level = Logger::WARN
end

