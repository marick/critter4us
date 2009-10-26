class DropView008 < Sequel::Migration

  def up
    puts '==== No longer using expanded uses view'
    begin
      DB.create_or_replace_view(:expanded_uses, DB[:uses]) # Hack - no way to test for view
      DB.drop_view(:expanded_uses)
    rescue Exception
      puts "No view to drop - already dropped"
    end
  end

  def down
    puts "==== Can't put back expanded uses view"
  end
end
