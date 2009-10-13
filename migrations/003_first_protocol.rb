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
<li>
Thoroughly wash and dry the vulva.
</li>
<li>
With a gloved hand, identify the floor of the pelvis. 
</li>
<li>
Administer local anesthesia at the surgical site using 10-12 mls of 2% lidocaine SQ.  Test the area for loss of sensation.
</li>
<li>
Remove thin strips (1/4-1/2 inch) of vaginal mucosa at the mucocutaneous junction using scissors; strips should extend from the level of the floor of the pelvis to the dorsal commisure of the vulva.
</li>
<li>
Suture the vulva closed at the stripping site using absorbable sutures. 
</li>
<li>
Place the <b>surgery report</b> in the animal's medical record.
</li>
<li>
Monitor the mare daily for healing and <b>record findings in medical record</b>.  
</li>
<li>
If a mare is to have her Caslick's opened, this may be done either under local anesthesia or by stretching of the old scar tissue and snipping with a pair of scissors while restrained in stocks, tranquilized or twitched.
</li>
<li>
<span style='color:red'><i>Limits:</i></span> Each mare may only be subjected to the Caslick's procedure once (unless the mare would benefit clinically otherwise)
</li>
<li>
<span style='color:red'>NOTE:</span>  The Caslick's procedure may be demonstrated for students but must be performed by interns, residents or faculty members. 
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
