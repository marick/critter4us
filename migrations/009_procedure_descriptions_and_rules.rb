require 'model/requires'

class ProcedureDescriptionsAndRules009 < Sequel::Migration

  def up
    puts "==== Creating exclusion_rules table"
    DB.create_table :exclusion_rules do
      primary_key :id
      foreign_key :procedure_id, :procedures
      String :rule
    end

    puts '==== Tweaking procedures'
    Procedure.create(:name => 'transabdominal ultrasonography', :days_delay => 0)
    Procedure[:name => "orogastric intubation (cows)"].update(:name => "orogastric intubation")
    Procedure[:name => "milk collection (cows)"].update(:name => "milk collection")

    unless ENV['RACK_ENV'] == 'test'
      puts "==== Overwriting procedure descriptions and rules"
      require 'admin/procedure-descriptions'
      ProcedureDescriptionSetter.new.describe_procedures
      puts "#{DB[:exclusion_rules].count} rules"
      puts "#{DB[:procedure_descriptions].count} procedure descriptions"
    end

    
  end

  def down
    puts "==== Dropping all procedure descriptions"
    DB[:procedure_descriptions].delete
    puts "Dropping exclusion rules table"
    DB.drop_table :exclusion_rules
    puts "==== Putting procedures back as before"
    Procedure.filter(:name => 'transabdominal ultrasonography').delete
    Procedure[:name => "orogastric intubation"].update(:name => "orogastric intubation (cows)")
    Procedure[:name => "milk collection"].update(:name => "milk collection (cows)")
  end
end
