require './strangled-src/util/constants'
require './strangled-src/model/requires'
require 'pp'

NOTE="<span style='color:red'>NOTE:</span>"

class Sheath017 < Sequel::Migration

  def data
    [ ["sheath cleaning (horses)", 0, "equine", "HorsesOnly", SHEATH_CLEANING]
    ]
  end

  def up
    puts "==== adding sheath cleaning"
    data.each do | name, days_delay, species, rule, description | 
      procedure = Procedure.create(:name => name, :days_delay => days_delay)
      ProcedureDescription.create(:procedure => procedure,
                                  :animal_kind => species,
                                  :description => description)
      DB[:exclusion_rules].insert(:procedure_id => procedure.id,
                                  :rule => rule)
      Procedure.recalculate_exclusions
    end
  end

  def down
    puts "==== deleting sheath cleaning"
    data.each { | clump | Procedure[:name => clump[0]].destroy }
  end

SHEATH_CLEANING  ="
<b>Sheath Cleaning: Horses</b>
<ul>
<li>
Sheath cleaning is part of proper routine care and husbandry of male horses.  It is done most safely and easily with mild sedation.  Sheath cleaning can be a sedated procedure by itself or combined with other routine procedures that require sedation, such as teeth floating.  The penis is manually extracted from the sheath and cleaned with warm soap and water to remove smegma and other debris that gets trapped inside the sheath.
</li>
</ul>
"

end
