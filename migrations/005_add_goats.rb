require 'model/animal'

class Population < Sequel::Migration

  def up
    puts '==== adding goats'
    DB[:human_and_protocol_kinds].insert(:kind => 'goat', :protocol_kind => 'caprine')
    Animal.create(:name => 'goat  1', :kind => 'goat')
    Animal.create(:name => 'goat  2', :kind => 'goat')
    Animal.create(:name => 'goat  3', :kind => 'goat')
    Animal.create(:name => 'goat  4', :kind => 'goat')
    Animal.create(:name => 'goat  5', :kind => 'goat')
    Animal.create(:name => 'goat  6', :kind => 'goat')
    Animal.create(:name => 'goat  7', :kind => 'goat')
    Animal.create(:name => 'goat  8', :kind => 'goat')
    Animal.create(:name => 'goat  9', :kind => 'goat')
    Animal.create(:name => 'goat 10', :kind => 'goat')
    Animal.create(:name => 'goat 11', :kind => 'goat')
  end

  def down
    puts '==== removing goats'
    DB[:human_and_protocol_kinds].filter(:protocol_kind => 'caprine').delete
    DB[:animals].filter(:kind => 'goat').delete
  end
end
