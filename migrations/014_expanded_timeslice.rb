require 'util/constants'
require 'model/requires'
require 'pp'

class ExpandedTimeslice014 < Sequel::Migration
  def up
    puts "==== deleting left-over column"
    DB.drop_column :reservations, :morning

    puts "==== adding bit(3) field for TimeSet and separate start/end dates (for code migration)"
    DB.add_column :reservations, :first_date, Date
    DB.add_column :reservations, :last_date, Date
    DB.add_column(:reservations, :time_bits, :bit, :size => 3, :null => false, 
                  :default => "000")


    puts "==== copying values in new form"
    DB[:reservations].filter(:time => MORNING).update(:time_bits => "100")
    DB[:reservations].filter(:time => AFTERNOON).update(:time_bits => "010")
    DB[:reservations].filter(:time => EVENING).update(:time_bits => "001")

    DB[:reservations].update(:first_date => :date)
    DB[:reservations].update(:last_date => :date)

    puts "==== making new tables"
    # DB.create_table :timeslices do
    #   primary_key :id
    #   Date :first_date, :null => false
    #   Date :last_date, :null => false
    #   bit :time_bits, :size => 3, :null => false
    # end

    DB.create_table :excluded_because_in_use do 
      primary_key :id
      Date :first_date, :null => false
      Date :last_date, :null => false
      bit :time_bits, :size => 3, :null => false
      foreign_key :reservation_id, :reservations
      foreign_key :animal_id, :animals
    end

    DB.create_table :excluded_because_of_blackout_period do
      primary_key :id
      Date :first_date, :null => false
      Date :last_date, :null => false
      bit :time_bits, :size => 3, :null => false
      foreign_key :reservation_id, :reservations
      foreign_key :animal_id, :animals
      foreign_key :procedure_id, :procedures
    end

    DB.create_table :excluded_because_of_animal do 
      primary_key :id
      foreign_key :animal_id, :animals
      foreign_key :procedure_id, :procedures
    end

    # ==== filling new tables

    Reservation.each do | reservation |
      reservation.animals.each do | animal | 
        DB[:excluded_because_in_use].insert(:first_date => reservation.values[:first_date],
                                            :last_date => reservation.values[:last_date],
                                            :time_bits => reservation.values[:time_bits],
                                            :reservation_id => reservation.values[:id],
                                            :animal_id => animal.id)
      end
      reservation.uses.each do | use | 
        animal = Animal[use.animal_id]
        procedure = Procedure[use.procedure_id]
        
        next if procedure.days_delay == 0

        dataset = DB[:excluded_because_of_blackout_period]

        dataset.insert(:first_date => reservation.values[:first_date] - procedure.days_delay + 1,
                       :last_date => reservation.values[:last_date] + procedure.days_delay - 1,
                       :time_bits => reservation.values[:time_bits],
                       :reservation_id => reservation.values[:id],
                       :animal_id => animal.id,
                       :procedure_id => procedure.id)
      end
    end

    DB[:exclusion_rules].all do | row | 
      rule_class = Rule.const_get(row[:rule])
      procedure = Procedure[row[:procedure_id]]
      rule = rule_class.new(procedure)
      Animal.each do | animal | 
        if rule.animal_excluded?(animal)
          puts "No #{procedure.name} for #{animal.procedure_description_kind} #{animal.name} (#{rule.class})."
          DB[:excluded_because_of_animal].insert(:animal_id => animal.id,
                                                 :procedure_id => procedure.id)
        end
      end
    end
  end

  def down
    DB.drop_column :reservations, :time_bits
    DB.drop_column :reservations, :first_date
    DB.drop_column :reservations, :last_date
    # DB.drop_table :timeslices
    DB.drop_table :excluded_because_in_use
    DB.drop_table :excluded_because_of_blackout_period
    DB.drop_table :excluded_because_of_animal
    DB.add_column :reservations, :morning, :boolean # dummy so it can be deleted.
  end
end
