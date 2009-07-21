# Here goes your database connection and options:

require 'sequel'
DB = Sequel.mysql("critter4us", :host=>'localhost', :user=>'root', :password=>'')

# Here go your requires for models:
# require 'model/user'
