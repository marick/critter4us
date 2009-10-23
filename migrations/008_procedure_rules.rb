class AddProtocolTable004 < Sequel::Migration

  def up
    puts "==== Adding exclusion rules table"
    DB.create_table :exclusion_rules do 
      primary_key :id
      foreign_key :procedure_id, :procedures
      String :rule
    end
    rules = DB[:exclusion_rules]
    procedures = DB[:procedures]
    unless ENV['RACK_ENV'] == "test"
      rules.insert(:procedure_id => procedures[:name => 'nasogastric intubation (horses)'][:id],
                   :rule => 'HorsesOnly')
    end
    puts '==== No longer using expanded uses view'
    DB.drop_view(:expanded_uses)
  end

  def down
    puts "==== Removing exclusion rules table"
    DB.drop_table :exclusion_rules
    puts "==== Can't put back expanded uses view"
  end
end
