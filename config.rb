require 'sinatra/base'
require 'sequel'

Sinatra::Base.configure :test do 
DB = Sequel.postgres("critter4us-test", :host => 'localhost', :user => 'postgres', :password => 'c0wm4gnet')
#  DB = Sequel.sqlite
#  DB = Sequel.mysql("critter4us-test", :host=>'localhost',
#                    :user=>'root', :password=>'')
  require 'admin/tables'
  create_tables
end

Sinatra::Base.configure :development do 
  DB = Sequel.postgres("critter4us", :host => 'localhost', :user => 'postgres', :password => 'c0wm4gnet')
#  DB = Sequel.mysql("critter4us", :host=>'localhost',
#                    :user=>'root', :password=>'')
end

Sinatra::Base.configure :production do 
  DB = Sequel.connect(ENV['DATABASE_URL'])
end
