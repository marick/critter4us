require 'rubygems' 
require 'ramaze' 
require 'json' 
require 'sequel'

DB = Sequel.mysql("critter4us", :host=>'localhost', :user=>'root', :password=>'')

DB.create_table! :procedures do
  primary_key :id
  String :name
  int :days_delay
end


class Procedure  < Sequel::Model
  one_to_many :uses
end

Procedure.create(:name => 'venipuncture', :days_delay => 14)
Procedure.create(:name => 'floating', :days_delay => 20)
Procedure.create(:name => 'physical exam', :days_delay => 0)



DB.create_table! :animals do
  primary_key :id
  String :name
  String :kind
end

class Animal < Sequel::Model
  one_to_many :uses
end

Animal.create(:name => 'bossy', :kind => 'bovine')
Animal.create(:name => 'suzy', :kind => 'bovine')
Animal.create(:name => 'betsy', :kind => 'bovine')


DB.create_table! :uses do
  primary_key :id
  int :procedure_id
  int :animal_id
  Date :date
end

class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
end

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



