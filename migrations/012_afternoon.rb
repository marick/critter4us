require 'util/constants'

class Guicho_011 < Sequel::Migration
  def up
    puts "==== adding a :day_segment string to hold morning, afternoon, or evening"
    DB.add_column :reservations, :day_segment, String
    DB[:reservations].filter(:morning => true).update(:day_segment => MORNING)
    DB[:reservations].filter(:morning => false).update(:day_segment => AFTERNOON)
  end

  def down
    puts "==== remove :day_segment column"
    DB.drop_column :reservations, :day_segment
  end

end
