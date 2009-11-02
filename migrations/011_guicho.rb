require 'model/animal'
require 'model/procedure'

class Guicho_011 < Sequel::Migration
  def up
    puts "==== Adding Guicho"
    Animal.create(:name => 'Guicho', :kind => 'gelding', :procedure_description_kind => 'equine')
  end

  def down
    puts "==== Deleting Guicho"
    Animal[:name => 'Guicho'].delete
  end

end
