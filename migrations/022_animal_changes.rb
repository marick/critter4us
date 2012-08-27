require './strangled-src/util/constants'
require './strangled-src/model/requires'
require 'pp'

class AnimalChanges022 < Sequel::Migration

  def up
    puts "==== reallowing horses"
    DB[:animals].filter(:name => "Finn").update(:date_removed_from_service => nil)
    DB[:animals].filter(:name => "Appy").update(:date_removed_from_service => nil)
    DB[:animals].filter(:name => "Vocalist").update(:date_removed_from_service => nil)

    DB[:animals].filter(:name => "Spot").update(:kind => "horse")
    DB[:animals].filter(:name => "Sport").update(:kind => "horse")
    DB[:animals].filter(:name => "Blondie").update(:kind => "horse")
    DB[:animals].filter(:name => "Privet").update(:kind => "horse")
  end

  def down
    puts "==== reallowing horses"
    throw "NOT DONE"
    Procedure.recalculate_exclusions
  end
end
