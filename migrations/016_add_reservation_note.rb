require './util/constants'

class ReservationNote016 < Sequel::Migration
  def up
    puts "==== reservation note"
    DB.add_column :reservations, :note, String, :null => false, :default => ''
  end

  def down
    DB.drop_column :reservations, :note
  end
end
