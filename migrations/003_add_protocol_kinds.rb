class AddProtocolKinds003 < Sequel::Migration

  def up
    puts "==== Creating table that maps two ways of describing animal kinds"
    DB.create_table :human_and_protocol_kinds do 
      primary_key :id
      String :kind
      String :protocol_kind
    end

    DB[:human_and_protocol_kinds].insert(:kind => 'stallion', :protocol_kind => 'equine')
    DB[:human_and_protocol_kinds].insert(:kind => 'gelding', :protocol_kind => 'equine')
    DB[:human_and_protocol_kinds].insert(:kind => 'mare', :protocol_kind => 'equine')
    DB[:human_and_protocol_kinds].insert(:kind => 'cow', :protocol_kind => 'bovine')
  end

  def down
    puts "==== Dropping table that maps two ways of describing animal kinds"
    DB.drop_table :human_and_protocol_kinds
  end
end
