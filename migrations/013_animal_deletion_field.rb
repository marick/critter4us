require 'util/constants'

class AnimalDeletion013 < Sequel::Migration
  def up
    puts "==== adding deletion flag for animals"
    DB.add_column :animals, :date_removed_from_service, Date, :null => true
  end

  def down
    puts "==== remove animal deletion"
    DB.drop_column :animals, :date_removed_from_service
  end

end
