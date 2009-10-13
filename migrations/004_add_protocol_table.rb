class AddProtocolTable004 < Sequel::Migration

  def up
    puts "==== Creating table to hold protocols"
    DB.create_table :protocols do 
      primary_key :id
      String :animal_kind
      foreign_key :procedure_id, :procedures
      String :description
    end
  end

  def down
    puts "==== Dropping table to hold protocols"
    DB.drop_table :protocols
  end
end
