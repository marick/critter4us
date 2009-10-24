class RenameProtocols007 < Sequel::Migration

  def up
    puts "==== Renaming protocol table"
    DB.rename_table :protocols, :procedure_descriptions
    DB.rename_table :human_and_protocol_kinds, :gui_and_procedure_description_kinds
    DB.rename_column :gui_and_procedure_description_kinds, :protocol_kind, :procedure_description_kind
  end

  def down
    puts "==== Un-renaming protocols"
    DB.rename_table :procedure_descriptions, :protocols
    DB.rename_column :gui_and_procedure_description_kinds, :procedure_description_kind, :protocol_kind
    DB.rename_table :gui_and_procedure_description_kinds, :human_and_protocol_kinds
  end
end
