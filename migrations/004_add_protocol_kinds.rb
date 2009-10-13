class AddProtocolKinds < Sequel::Migration

  def up
    puts "==== Creating protocol kind table"
    DB.create_table :kind_mappings do 
      primary_key :id
      String :kind
      String :protocol_kind
    end

    DB[:kind_mappings].insert(:kind => 'stallion', :protocol_kind => 'equine')
    DB[:kind_mappings].insert(:kind => 'gelding', :protocol_kind => 'equine')
    DB[:kind_mappings].insert(:kind => 'mare', :protocol_kind => 'equine')
    DB[:kind_mappings].insert(:kind => 'cow', :protocol_kind => 'bovine')
  end

  def down
    puts "==== Dropping protocol kind table"
    DB.drop_table :kind_mappings
  end
end
