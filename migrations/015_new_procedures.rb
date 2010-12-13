require 'util/constants'
require 'model/requires'
require 'pp'

NOTE="<span style='color:red'>NOTE:</span>"

class NewProcedures015 < Sequel::Migration

  def data
    [ ["nasal swab (cattle)", 0, "bovine", "BovineOnly", NASAL_SWAB],
      ["lameness exam (horses)", 0, "equine", "HorsesOnly", LAMENESS],
      ["superovulation (cattle)", 21, "bovine", "BovineOnly", SUPEROVULATION],
      ["embryo flush (cattle)", 21, "bovine", "BovineOnly", EMBRYO_FLUSH],
    ]
  end

  def up
    puts "==== adding new procedures"
    data.each do | name, days_delay, species, rule, description | 
      procedure = Procedure.create(:name => name, :days_delay => days_delay)
      ProcedureDescription.create(:procedure => procedure,
                                  :animal_kind => species,
                                  :description => description)
      DB[:exclusion_rules].insert(:procedure_id => procedure.id,
                                  :rule => rule)
      Procedure.note_excluded_animals(Animal.all)
    end
  end

  def down
    puts "==== deleting new procedures"
    data.each { | clump | Procedure[:name => clump[0]].destroy }
  end

NASAL_SWAB  ="
<b>Nasal Swab: Cattle</b>
<ul>
<li>
Insert a sterile swab into the nasal passages and make contact with the mucosal lining being careful that no other surfaces are contacted.
</li>
</ul>
"

LAMENESS  ="
<b>Lameness Examination: Horses</b>
<ul>
<li>
In order to teach lameness examination, the following activities may be performed: physical examination (e.g., palpation and flexion of limbs), walking or jogging the horse, hoof examination and care (lifting, cleaning, and trimming of hooves, use of hoof testers, application or removal of shoes), radiography or ultrasonography of the limbs, and mock nerve blocks using subcutaneous injection of saline.
</li>
<li>
If joints are to be tapped/synovial fluid collected, these procedures must be reserved separately. They have specific recordkeeping requirements and limits.
</li>
</ul>
"

SUPEROVULATION="
<b>Superovulation: Cattle</b>
<ul>
<li>
Administer either 50 mg pFSH (2.5 mls Folltropin-V) or 2.2 mg of FSH (2.5 mls Ovagen) intramuscularly using an 18 gauge, 1.5 inch needle once daily for 4 days according to manufacturer's instructions.
<ul>
<li>
On the third day of superovulation, remove the CIDR (if the hormonal method was used to synchronize follicular wave).
</li>
</ul>
</li>
<li>
Administer 25 mg dinoprost (5 mls Lutalyse) or 500 ug cloprostenol (2 mls Estrumate) intramuscularly using an 18 gauge, 1.5 inch needle to lyse the corpus luteum and induce estrus.
</li>
</ul>
"

EMBRYO_FLUSH="
<b>Embryo Flush: Cattle</b>

<ul>
<li>
Embryos may be flushed from the uterus on days 6, 7, or 8 after heat.
</li>
<li>
Prior to flushing, administer caudal epidural anesthesia to facilitate catheter passage through the cervix.
<ul>
<li>
Clip the site over the sacrococcygeal region.
</li>
<li>
Aseptically prepare the site by scrubbing with surgical soap and rinsing with 70% alcohol
</li>
<li>
Insert an 18 gauge, 1.5 inch needle into the sacrococcygeal or 1st intercoccygeal space.
</li>
<li>
Inject 3-5 mls of 2% lidocaine into the epidural space.
</li>
<li>
Measure the success of the block by pricking the skin around the vulva with a needle and check for loss of tail tone.
</li>
</ul>
</li>
<li>
Tie the tail out of the way (to the cow).
</li>
<li>
Scrub the perineal area using soap and water.
</li>
<li>
Aseptically pass the flush catheter into the uterus
</li>
<li>
Flush the uterus with 1-2 Liters of phosphate buffered saline (PBS) or an equivalent flushing solution to obtain the embryos.
</li>
<li>
After flushing, administer a single IM dose of prostaglandin (Lutalyse or Estrumate), which will re-induce estrus in 2-5 days. 
</li>
<li>
#{NOTE} Allow the cow to cycle <b>at least</b> once more before a new superovulation/flush is attempted.
</li>
</ul>
"

end
