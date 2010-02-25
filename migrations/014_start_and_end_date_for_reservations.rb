require 'util/constants'

class StartAndEndDateForReservations014 < Sequel::Migration
  def up
    puts "==== adding separate boolean fields for morning, afternoon, evening"
    DB.drop_column :reservations, :morning

    DB.add_column :reservations, :first_date, Date
    DB.add_column :reservations, :last_date, Date
    DB.add_column :reservations, :morning, :boolean, :default => false
    DB.add_column :reservations, :afternoon, :boolean, :default => false
    DB.add_column :reservations, :evening, :boolean, :default => false

    puts "==== copying values in new form"
    DB[:reservations].filter(:time => MORNING).update(:morning => true)
    DB[:reservations].filter(:time => AFTERNOON).update(:afternoon => true)
    DB[:reservations].filter(:time => EVENING).update(:evening => true)

    DB[:reservations].update(:first_date => :date)
    DB[:reservations].update(:last_date => :date)

    puts "==== deleting old columns"
    DB.drop_column :reservations, :date
    DB.drop_column :reservations, :time
  end

  def down
    raise "==== No down needed yet for #{self.class}"
  end

end
