require './strangled-src/util/constants'
require './strangled-src/model/requires'
require 'pp'

NOTE="<span style='color:red'>NOTE:</span>"

class Transabdominal2_19 < Sequel::Migration

  def data
    [ ["sheath cleaning (horses)", 0, "equine", "HorsesOnly", SHEATH_CLEANING]
    ]
  end

  def procedure
    Procedure[:name => "transabdominal ultrasonography"]
  end


  def up
    puts "==== Fixing Transabdominal procedure description"
    description = ProcedureDescription.filter(:procedure => procedure).first
    description.animal_kind = "any species"
    description.description = TRANSABDOMINAL_ALL
    description.save
  end

  def down
    puts "==== Unfixing Transabdominal procedure description"
    puts "(Not really doing anything)"
  end

  TRANSABDOMINAL_ALL="
<b>Transabdominal Ultrasound:  All Species</b>
<ul>
<li>
Place transducer coated with contact gel in flank area.
</li>
<li>
Examine abdomen for uterine fluid, feti, or placentomes.
</li>
<li>
#{NOTE}  Animals may be ultrasounded multiple times per lab as long as they are tolerating it well.  
</li>
</ul>
"


end
