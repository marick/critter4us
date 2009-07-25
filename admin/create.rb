require 'rubygems' 
require 'json' 
require 'sinatra/base'

Sinatra::Base.set :environment, :development
require '../config'
require 'tables'
create_tables
require '../model'


Procedure.create(:name => 'venipuncture', :days_delay => 14)
Procedure.create(:name => 'floating', :days_delay => 20)
Procedure.create(:name => 'physical exam', :days_delay => 0)


Animal.create(:name => 'bossy', :kind => 'bovine')
Animal.create(:name => 'suzy', :kind => 'bovine')
Animal.create(:name => 'betsy', :kind => 'bovine')


bossy = Animal[:name => 'bossy']
betsy = Animal[:name => 'betsy']
suzy = Animal[:name => 'suzy']
procedure = Procedure[:name => 'venipuncture']

Use.create(:animal => bossy, :procedure => procedure, :date => Date.today - 3)
Use.create(:animal => suzy, :procedure => procedure, :date => Date.new(1969))
Use.create(:animal => betsy, :procedure => procedure, :date => Date.today - 30)

puts procedure.uses_dataset.filter(:date => (Date.new(1969)..(Date.today-14))).inspect

procedure.uses_dataset.filter(:date => (Date.new(1969)..(Date.today-14))).each do | x | 
  puts x.date
end



