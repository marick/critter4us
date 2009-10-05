class Creation < Sequel::Migration

  def up
    puts "==== Fake Creating tables"
  end

  def down
    puts "==== Dropping all tables"
  end
end
