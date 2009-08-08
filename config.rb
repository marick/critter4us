require 'sinatra/base'
require 'sequel'

Sinatra::Base.configure :test do 
#  DB = Sequel.sqlite
  DB = Sequel.mysql("critter4us-test", :host=>'localhost',
                    :user=>'root', :password=>'')
  require 'admin/tables'
  create_tables
end

Sinatra::Base.configure :development do 
  DB = Sequel.mysql("critter4us", :host=>'localhost',
                    :user=>'root', :password=>'')
end
