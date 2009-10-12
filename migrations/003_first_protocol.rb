require 'model/animal'
require 'model/procedure'

class Population < Sequel::Migration

  def up
    puts "Adding protocol column"
    DB.alter_table :procedures do
      add_column :protocol, String
    end
    DB[:procedures].filter(:name => "Caslick's operation (horses)").update(:protocol => "<b>Caslick's Operation (Vulvoplasty): Horses</b>
<ul>
<li>
Bandage the horse's tail and tie it out of the way.
</li>
</ul>
")
  end

  def down
    puts "Removing protocol column"
    DB.alter_table :procedures do
      drop_column :protocol
    end
  end
end
