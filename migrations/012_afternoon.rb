require 'util/constants'

class Guicho_011 < Sequel::Migration
  def up
    puts "==== adding a :time string to hold morning, afternoon, or evening"
    DB.add_column :reservations, :time, String
    DB[:reservations].filter(:morning => true).update(:time => MORNING)
    DB[:reservations].filter(:morning => false).update(:time => AFTERNOON)
  end

  def down
    puts "==== remove :time column"
    DB.drop_column :reservations, :time
  end

end
