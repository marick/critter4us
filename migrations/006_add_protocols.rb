require 'model/requires'

class AddProtocols006 < Sequel::Migration

  def up
    puts '==== adding protocols'
    Protocol.create(:procedure => Procedure[:name => "Caslick's operation (horses)"],
                    :animal_kind => 'equine',
                    :description => CASLICKS_HORSES)
    Protocol.create(:procedure => Procedure[:name => "response to anesthetic drugs"],
                    :animal_kind => Protocol::CATCHALL_KIND,
                    :description => ANESTHETIC_ALL)
    Protocol.create(:procedure => Procedure[:name => "restraint and handling"],
                    :animal_kind => "bovine",
                    :description => RESTRAINT_CATTLE)
    Protocol.create(:procedure => Procedure[:name => "physical examination"],
                    :animal_kind => Protocol::CATCHALL_KIND,
                    :description => PHYSICAL_EXAM_ALL)
    Protocol.create(:procedure => Procedure[:name => "hoof exam and care"],
                    :animal_kind => "bovine",
                    :description => HOOF_EXAM_CATTLE)
    Protocol.create(:procedure => Procedure[:name => "milk collection (cows)"],
                    :animal_kind => "bovine",
                    :description => MILK_COLLECTION_CATTLE)
    Protocol.create(:procedure => Procedure[:name => "superficial ultrasonography"],
                    :animal_kind => Protocol::CATCHALL_KIND,
                    :description => SUPERFICIAL_ULTRASONOGRAPHY_ALL)
    Protocol.create(:procedure => Procedure[:name => "opthalmic examination"],
                    :animal_kind => "bovine",
                    :description => OPTHALMIC_CATTLE)
    Protocol.create(:procedure => Procedure[:name => "tail venipuncture (cows)"],
                    :animal_kind => "bovine",
                    :description => TAIL_VENIPUNCTURE_CATTLE)
    Protocol.create(:procedure => Procedure[:name => "jugular venipuncture"],
                    :animal_kind => "bovine",
                    :description => JUGULAR_VENIPUNCTURE_CATTLE)
    Protocol.create(:procedure => Procedure[:name => "orogastric intubation (cows)"],
                    :animal_kind => "bovine",
                    :description => OROGASTRIC_INTUBATION_CATTLE)
    Protocol.create(:procedure => Procedure[:name => "injection (IM, SQ, IV)"],
                    :animal_kind => "bovine",
                    :description => INJECTION_TECHNIQUE_CATTLE)
    Protocol.create(:procedure => Procedure[:name => "reproductive tract palpation"],
                    :animal_kind => "bovine",
                    :description => REPRO_ULTRASOUND_CATTLE)
    Protocol.create(:procedure => Procedure[:name => "transrectal ultrasonography"],
                    :animal_kind => "bovine",
                    :description => REPRO_ULTRASOUND_CATTLE)
    Protocol.create(:procedure => Procedure[:name => "oral medication"],
                    :animal_kind => "bovine",
                    :description => ORAL_MEDICATION_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'vaginal examination (manual) (cows)'],
                    :animal_kind => "bovine",
                    :description => MANUAL_VAGINAL_EXAM_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'uterine culture'],
                    :animal_kind => Protocol::CATCHALL_KIND,
                    :description => UTERINE_CULTURE_ALL)
    Protocol.create(:procedure => Procedure[:name => 'semen collection'],
                    :animal_kind => "bovine",
                    :description => SEMEN_COLLECTION_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'artificial insemination'],
                    :animal_kind => "bovine",
                    :description => AI_CATTLE)
#    Protocol.create(:procedure => Procedure[:name => ''],
#                   :animal_kind => "bovine",
#                    :description => PERITONEAL_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'urine collection by catheter'],
                    :animal_kind => "bovine",
                    :description => URINE_COLLECTION_FEMALE_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'IV catheter placement (cattle)'],
                    :animal_kind => "bovine",
                    :description => IV_CATHETER_PLACEMENT_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'blood collection for transfusion'],
                    :animal_kind => "bovine",
                    :description => BLOOD_COLLECTION_FOR_TRANSFUSION_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'transtracheal wash (cattle)'],
                    :animal_kind => "bovine",
                    :description => TRANSTRACHEAL_FLUID_ASPIRATION_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'CSF collection (lumbosacral)'],
                    :animal_kind => "bovine",
                    :description => CSF_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'rumen fluid collection (tube)'],
                    :animal_kind => "bovine",
                    :description => CANNULATED_RUMEN_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'rumen fluid collection (rumenocentesis)'],
                    :animal_kind => "bovine",
                    :description => RUMENOCENTESIS)
    Protocol.create(:procedure => Procedure[:name => 'caudal epidural (cattle)'],
                    :animal_kind => "bovine",
                    :description => CAUDAL_EPIDURAL_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'paravertebral anesthesia (cattle)'],
                    :animal_kind => "bovine",
                    :description => PARAVERTEBRAL_ANESTHESIA_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'embryo transfer (cattle)'],
                    :animal_kind => "bovine",
                    :description => EMBRYO_TRANSFER_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'follicular aspiration (IVF)'],
                    :animal_kind => "bovine",
                    :description => ASPIRATION_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'restraint and handling'],
                    :animal_kind => "equine",
                    :description => RESTRAINT_HORSES)
    Protocol.create(:procedure => Procedure[:name => 'hoof exam and care'],
                    :animal_kind => "equine",
                    :description => HOOF_EXAM_CATTLE)
    Protocol.create(:procedure => Procedure[:name => 'jugular venipuncture'],
                    :animal_kind => "equine",
                    :description => JUGULAR_VENIPUNCTURE_HORSES)
    Protocol.create(:procedure => Procedure[:name => "injection (IM, SQ, IV)"],
                    :animal_kind => "equine",
                    :description => INJECTION_TECHNIQUES_HORSES)
    Protocol.create(:procedure => Procedure[:name => "reproductive tract palpation"],
                    :animal_kind => "equine",
                    :description => REPRO_ULTRASOUND_HORSES)
    Protocol.create(:procedure => Procedure[:name => "transrectal ultrasonography"],
                    :animal_kind => "equine",
                    :description => REPRO_ULTRASOUND_HORSES)
    Protocol.create(:procedure => Procedure[:name => "oral medication"],
                    :animal_kind => "equine",
                    :description => ORAL_MEDICATION_HORSES)
    Protocol.create(:procedure => Procedure[:name => "vaginal examination (speculum)"],
                    :animal_kind => "equine",
                    :description => VAGINAL_SPECULUM_HORSES)
  end

  def down
    puts "==== emptying Protocol table"
    DB[:protocols].delete
  end

LIMITS="<span style='color:red'><i>Limits:</i></span>"
NOTE="<span style='color:red'>NOTE:</span>"

ANESTHETIC_ALL =
"
<b>Responses to Anesthetic Drugs: All Species</b>
<ul>
<li>
Animals may be tranquilized, sedated or anesthetized using injectable drugs under the supervision of an experienced anesthesia technician in order to demonstrate typical responses to commonly used drugs.   
</li>
<li>
Animals must be kept in a protected environment and closely monitored until complete recovery.  
</li>
<li>
Animals may be intubated, fitted with external monitors, administered oxygen and/or administered reversal agents.
</li>
</ul>
"

CASLICKS_HORSES =
"<b>Caslick's Operation (Vulvoplasty): Horses</b>
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
#{LIMITS} Each mare may only be subjected to the Caslick's procedure once (unless the mare would benefit clinically otherwise)
</li>
<li>
#{NOTE}  The Caslick's procedure may be demonstrated for students but must be performed by interns, residents or faculty members. 
</li>

</ul>
"

RESTRAINT_CATTLE="
<b>Restraint and Handling: Cattle </b>
<ul>
<li>
The following may be used and/or demonstrated: 
<ul>
<li>
Cattle may be restrained in a chute, headgate, or tie stall, or manually restrained.
</li>
<li>
The head may be tied or a tail press, nose tongs or flank hold applied for up to 5 minutes.
</li>
<li>
Cattle may be led by halter (if trained to do so) or herded.
</li>
<li>
Cattle may be placed on a tilt table for hoof trimming.
</li>
</li>
</ul>
"

PHYSICAL_EXAM_ALL="
<b>Routine Physical Examination, Palpation of Superficial Structures and Identification of Procedural Landmarks: All Species</b>
<ul>
<li>
The following may be demonstrated or performed: 
<ul>
<li>
Measurement of rectal temperature, heart rate and respiratory rate
</li>
<li>
Auscultation of the chest and abdomen
</li>
<li>
Evaluation of mucous membranes and skin tent
</li>
<li>
Assessment of gait and stance
</li>
<li>
Palpation of external structures (e.g. joints, tendons, lymph nodes)
</li>
<li>
Identification (by palpation) of procedural landmarks
</li>
<li>
Examination of the oral cavity
</li>
<li>
Manual stimulation for urine collection
</li>
</ul>
</li>
</ul>
"

HOOF_EXAM_CATTLE="
<b>Hoof Examination and Hoof Care: Cattle</b>
<ul>
<li>
Hooves may be lifted, examined, cleaned and trimmed.
</li>
</ul>
"

MILK_COLLECTION_CATTLE="
<b>Milk Collection: Cattle</b>
<ul>
<li>
<b>Up to 20 mls</b> of milk may be removed from each teat, followed by spraying of the teat with an approved germicide.
</li>
</ul>
"
SUPERFICIAL_ULTRASONOGRAPHY_ALL="
<b>Ultrasonography of Tissues and Organs: ALL </b>
<ul>
<li>
Organs and tissues may be imaged using an ultrasound probe placed on the body surface.
</li>
</ul>
"

OPTHALMIC_CATTLE="
<b>Ophthalmic Examination: Cattle</b>
<ul>
<li>
Routine ophthalmic examination may be performed using a penlight or ophthalmoscope.
</li>
<li>
If mydriasis (dilation of the pupil) is required, this may be induced by topical application of Mydriacyl (1% tropicamide; 3 drops). Cattle must be maintained indoors for at least 12 hours to ensure the effects of the mydriatic have completely resolved before being allowed to go outside. 
</li>
<li>
Intraocular pressure may be measured using a tonometer on the surface of the cornea.
</li>
<li>
The cornea may be stained using fluorescein dye.
</li>
</ul>
"

TAIL_VENIPUNCTURE_CATTLE="
<b>Venipuncture - Coccygeal Vein: Cattle </b>
<ul>
<li>
Clean skin with alcohol.
</li>
<li>
Use an 18-20 gauge needle.                                                  
</li>
<li>
Collect <b>up to 12 mls</b> of blood in a vacutainer tube or syringe.
</li>
<li>
#{LIMITS} Blood may be collected <b>no more than twice</b> on a given animal in a given lab and <b>no more frequently than twice per week</b>.
<ul>
<li>
<b>Mark animals with chalk or paint stick</b> each time venipuncture is performed so that limits are not exceeded.
</li>
</ul>
</li>
<li>
<a href='http://video.google.com/videoplay?docid=-8766971907276110685'>Video</a>
</li>
</ul>
"

JUGULAR_VENIPUNCTURE_CATTLE="
<b>Venipuncture - Jugular Vein: Cattle</b>
<ul>
<li>
Use an 18-20 gauge needle.
</li>
<li>
Collect <b>up to 12 mls</b> of blood in a vacutainer tube or syringe.
</li>
<li>
#{LIMITS} Blood may be collected <b>no more than twice per side</b> on a given animal in a given laboratory and <b>no more frequently than twice per week</b>.
<ul>
<li>
<b>Mark animals with chalk or paint stick</b> each time venipuncture is performed so that limits are not exceeded.
</li>
</ul>
</li>
<li>
<a href='http://video.google.com/videoplay?docid=5179220614784488271'>Video</a>
</li>
</ul>
"

OROGASTRIC_INTUBATION_CATTLE="
<b>Orogastric Intubation (Stomach Tubing): Cattle </b>
<ul>
<li>
Two options: 
<ul>
<li>
Either place a speculum into the mouth and pass a stomach tube through the speculum into the rumen; OR
</li>
<li>
Pass a special flexible tube (e.g., Dirksen probe) through the mouth into the rumen. 
</li>
</ul>
</li>
<li>
A hand-held pump may be attached to the tube to aspirate rumen fluid for examination.
</li>
<li>
<a href='http://video.google.com/videoplay?docid=-5688701344067775389'>Video</a>
</li>
</ul>
"

INJECTION_TECHNIQUE_CATTLE="
<b>Injection Techniques: Cattle </b>
<ul>
<li>
The following injection techniques may be demonstrated or performed: SQ, IM, IV.
</li>
<li>
Use a 14-20 gauge needle depending on the size of the animal and the viscosity of fluid to be injected.
</li>
<li>
Inject no solution or <b>up to 5 mls</b> of sterile saline solution per site.
</li>
<li>
#{LIMITS} Injections may be given <b>no more than twice/animal</b> in a given lab and <b>no more frequently than twice/week</b>. 
<ul>
<li>
<b>Mark animal with chalk or paint stick</b> each time an injection is performed so that limits are not exceeded.
</li>
</ul>
</li>
</ul>
"

REPRO_ULTRASOUND_CATTLE="
<b>Reproductive Tract Palpation or Ultrasound Examination per Rectum: Cattle</b>
<ul>
<li>
Don a lubricated rectal sleeve.
</li>
<li>
<ul>
<li>
Infusing lubricant into the rectum is not necessary.
</li>
</ul>
Clean rectum of feces by hand.
</li>
<li>
Palpate the tract and/or use an ultrasound probe to visualize the tract.
</li>
<li>
#{NOTE} If blood is observed on the rectal sleeve, the procedure must be immediately stopped. If the animal kicks, vocalizes or shows more than momentary distress when the arm/probe is inserted, the procedure must be immediately stopped and not attempted again the same day. Ask the supervising veterinarian to assess the animal’s condition. 
</li>
</ul>
"

ORAL_MEDICATION_CATTLE="
<b>Administration of Oral Medication: Cattle</b>
<ul>
<li>
Saline or water may be administered into the mouth using a dose syringe. 
</li>
<li>
A balling gun or dosing forceps can be used to administer an empty gelatin capsule into the pharynx.
</li>
<li>
Alternatively, the equipment may simply be placed in the mouth without administering fluid or a capsule.
</li>
</ul>
"

MANUAL_VAGINAL_EXAM_CATTLE="
<b>Manual Vaginal Examination: Cattle</b>
<ul>
<li>
Clean the perineal area with surgical solution and rinse.
</li>
<li>
Apply lubricant to a gloved arm and insert the arm through the vulva into the vaginal vault to palpate the cervix and vagina.
</li>
<li>
#{NOTE} If the animal shows more than momentary distress when the arm is inserted, the procedure must be immediately discontinued and not attempted again the same day.  If blood is observed on the sleeve, the procedure must be immediately stopped and not attempted again the same day. Ask the supervising veterinarian to assess the animal’s condition. .
</li>
</ul>
"

UTERINE_CULTURE_ALL="
<b>Uterine Culture and Biopsy: All Animals</b>
<ul>
<li>
Clean the perineal area with surgical solution; rinse well.
</li>
<li>
Don a sterile, lubricated sleeve to guide a sheathed culture swab or biopsy instrument through the vagina and cervix and into the uterus.
</li>
<li>
Place a gloved lubricated hand into the rectum to guide the instrument to the appropriate site for sample collection.
</li>
<li>
#{LIMITS} More than one culture, but only <b><i>one</i> biopsy</b> may be conducted on a given animal on a given day.  The biopsy must not be performed more than <b>twice/month</b> on a given animal and must be <b>recorded in the animal’s medical record</b>.
</li>
</ul>
"

SEMEN_COLLECTION_CATTLE="
<b>Semen Collection: Cattle</b>
<ul>
<li>
Semen may be collected using an artificial vagina.
</li>
<li>
#{LIMITS} Semen may be collected no more than <b>once/animal/lab</b> and <b>no more than twice weekly</b>.
</li>
</ul>
"

AI_CATTLE="
<b>Artificial Insemination (Nonsurgical AI): Cattle</b>
<ul>
<li>
Clean the perineal area with surgical solution; rinse well.
</li>
<li>
Don a lubricated sleeve.
</li>
<li>
Introduce AI pipette into the vagina.
</li>
<li>
Grasp the cervix, per rectum, and pass the pipette into the uterus.
</li>
<li>
Saline may be infused.
</li>
<li>
#{NOTE} If blood is observed on the sleeve or pipette/catheter, the procedure must be immediately stopped and not attempted again the same day. If the animal kicks, vocalizes or shows more than momentary distress when the arm is inserted, the procedure must be immediately discontinued and not attempted again the same day. Ask the supervising veterinarian to assess the animal's condition. 
</li>
</ul>
"

PERITONEAL_CATTLE="
<b>Peritioneal Fluid Collection: Cattle</b>
<ul>
<li>
Clip the sample site.
</li>
<li>
Scrub the site with surgical soap and rinse with isopropyl alcohol or saline.
</li>
<li>
Inject 1-5 mls of 2% lidocaine subcutaneously over the site using a 16 or 18 gauge needle.
</li>
<li>
Make a small stab incision through the skin to allow introduction of a sterile blunt teat cannula.
</li>
<li>
Once the procedure is finished and the cannula removed, close the stab incision using tissue glue.
</li>
<li>
#{LIMITS} Participants may be allowed <b>up to 3 attempts</b> to obtain a sample provided the animal is tolerating the procedure well.  Only <b>one peritoneal fluid sample may be collected per animal per day</b>.  This procedure <b>must be recorded in the animal’s medical record</b>. 
</li>
</ul>
"

URINE_COLLECTION_FEMALE_CATTLE="
<b>Urine Collection via Urinary Catheter: Female Cattle</b>
<ul>
<li>
Carefully wash and rinse the vulva using surgical soap and sterile saline.
</li>
<li>
Use aseptic techniques to pass a sterile urinary catheter through the urethra and into the bladder.
</li>
</ul>
"

IV_CATHETER_PLACEMENT_CATTLE="
<b>IV Catheter Placement: Cattle</b>
<ul>
<li>
Restrain animal and tie head to one side.
</li>
<li>
Apply digital pressure to occlude the jugular vein and identify the location for the catheter placement.
</li>
<li>
Clip the site, scrub with surgical soap and rinse with 70% alcohol.
</li>
<li>
Aseptically inject 3-5 mls of 2% lidocaine subcutaneously at the catheter site.
</li>
<li>
Don sterile gloves.  
</li>
<li>
Tent the skin and make a small (0.5cm) stab incision through the skin with a scalpel.
</li>
<li>
Insert a 14 or 16 gauge catheter into the jugular vein.
</li>
<li>
Once blood enters the catheter, move the hub of the catheter almost parallel to the vein and push the catheter into the vein without moving the hub of the stylet.
</li>
<li>
Attach an injection cap or extension set to the hub of the catheter.
</li>
<li>
Suture the catheter to the skin using #3 vetafil in a horizontal mattress pattern (or remove immediately).
</li>
<li>
If sutured, remove the sutures before removing the catheter.  Apply pressure to the site using a gauze pad.
</li>
<li>
Close the skin wound with tissue glue.
</li>
<li>
#{LIMITS} Only <b>one jugular vein</b> may be catheterized in a given cow on a given day.  This procedure <b>must be recorded in the animal’s medical record</b>.  A cow may be catheterized no more frequently than <b>every two weeks</b> and only if there is <b>no evidence of phlebitis</b>.
</li>
<ul>
"
BLOOD_COLLECTION_FOR_TRANSFUSION_CATTLE="
<b>Blood Collection for Transfusion: Cattle</b>
<ul>
<li>
Restrain animal and sedate if necessary
</li>
<li>
<b>Up to 11L</b> of blood may be removed <b>each month</b> (assuming the donor cow weighs approximately 600 kg). 
</li>
<li>
Clip the hair over the jugular or mammary vein.
</li>
<li>
Aseptically prepare the site using surgical soap and 70% alcohol.
</li>
<li>
Block the site by injecting 2% lidocaine subcutaneously.
</li>
<li>
Use a large bore needle (12-16 gauge) to collect the blood into commercial bags or autoclaved bottles containing an anticoagulant; vacuum may be applied to the bottles to facilitate blood flow.
</li>
<li>
Monitor the cow for at least one hour post collection for adverse reactions.
</li>
<li>
It is generally not necessary to administer IV fluids to the cow.
</li>
<li>
<b>Record procedure and amount of blood collected in the animal’s medical record.</b>
</li>
</ul>
"

TRANSTRACHEAL_FLUID_ASPIRATION_CATTLE="
<b>Transtracheal Fluid Aspiration: Cattle</b>
<ul>
<li>
Restrain the head with two halters and the nose pointing up.
</li>
<li>
Palpate the tracheal rings and identify the space between rings for introduction of the needle.
</li>
<li>
Clip the site and aseptically prepare it by scrubbing with surgical soap and rinsing with 70% alcohol.
</li>
<li>
Inject 3-5 mls of 2% lidocaine subcutaneously.
</li>
<li>
Don sterile gloves and make a small stab incision through the skin using a scalpel.
</li>
<li>
Pass a 12-14 gauge, 2 inch needle between the tracheal rings and into the lumen of the trachea.
</li>
<li>
Pass an 8 fr. polyethylene catheter through the needle.
</li>
<li>
Inject 35 mls of sterile saline through the catheter.
</li>
<li>
 Aspirate through the catheter and collect up to 20 mls of fluid.
</li>
<li>
Close the stab incision using tissue glue after removing the needle and catheter.
</li>
<li>
#{LIMITS}  This procedure should only be attempted <b>once</b> per lab and animals may be used <b>no more frequently than every 2 weeks</b>. <b>Record procedure in animal's medical record.</b>
</li>
</ul>
"

CSF_CATTLE="
<b>Cerebrospinal Fluid Collection: Cattle</b>
<ul>
<li>
Identify the lumbosacral junction on the midline of the back caudal to the wings of the tuber coxae. 
</li>
<li>
Clip and aseptically prepare the site by scrubbing with surgical soap and rinsing with 70% alcohol.
</li>
<li>
Inject 3-5 mls of 2% lidocaine subcutaneously and intramuscularly.
</li>
<li>
Don sterile gloves and insert an 18 gauge, 6 inch spinal needle on the midline and perpendicular to the spine until it enters the subarachnoid space (if the needle hits/meets a vertebra, it may be withdrawn almost completely and redirected up to <b>3 times</b>).
</li>
<li>
Remove the stylet and aspirate <b>up to 5 mls</b> of CSF before replacing the stylet and removing the needle.
</li>
<li>
#{LIMITS}  CSF may be collected <b>once/lab</b> and animals may be used <b>no more frequently than every 2 weeks</b>. <b>Record procedure in animal's medical record.</b>
</li>
</ul>
"

CANNULATED_RUMEN_CATTLE="
<b>Rumen Fluid Collection: Cannulated Cattle</b>
<ul>
<li>
Remove the cannula plug.
</li>
<li>
Siphon rumen fluid into a bucket using a large bore (Kingman) tube.  Use water to create the siphon.
</li>
<li>
Remove <b>no more than 20 Liters</b> of rumen fluid/ collection.
</li>
<li>
Alternatively, if only a small volume of fluid is needed for transfaunation, rumen contents may be removed manually and squeezed to collect the fluid.  The fibrous  material should be replaced back into the cow.
</li>
<li>
Securely replace the cannula plug.
</li>
</ul>
"

RUMENOCENTESIS="
<b>Rumen Fluid Collection: Rumenocentesis</b>
<ul>
<li>
Rumen fluid may be collected through an orogastric tube or by rumenocentesis. To perform rumenocentesis:
</li>
<li>
Identify a location in the ventral, left flank, approximately 15 cm caudal to the last rib where the ventral sac of the rumen is easily palpable and has a fluid consistency.
</li>
<li>
Clip the site and aseptically prepare it by scrubbing with surgical soap and rinsing with 70% alcohol.
</li>
<li>
Inject 3-5 mls of 2% lidocaine subcutaneously and intramuscularly.
</li>
<li>
Have an assistant hold the tail over the back of the animal.
</li>
<li>
Insert a 16 gauge, 5 inch needle into the rumen.
</li>
<li>
Collect <b>up to 20 mls</b> of fluid.
</li>
<li>
#{LIMITS} Rumenocentesis may be attempted <b>up to 3 times/cow</b> on a given day. A given cow may not be sampled more frequently than <b>every 2 weeks</b>. <b>Record procedure in animal's medical record.</b>
</li>
</ul>
"

CAUDAL_EPIDURAL_CATTLE="
<b>Caudal Epidural Anesthesia: Cattle</b>
<ul>
<li>
Clip the site over the sacrococcygeal region.
</li>
<li>
Aseptically prepare the site by scrubbing with surgical soap and rinsing with 70% alcohol.
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
"

PARAVERTEBRAL_ANESTHESIA_CATTLE="
<b>Regional Anesthesia - Proximal Paravertebral Anesthesia: Cattle</b>
<ul>
Clip hair from the skin over the lumbar transverse processes.
</li>
<li>
Aseptically prepare the site by scrubbing with surgical soap and rinsing with 70% alcohol.
</li>
<li>
Using a 20 gauge needle, inject 3 mls of 2% lidocaine subcutaneously 5 cm from the dorsal midline at each of the 3 nerve block sites (1st-3rd lumbar vertebrae).
</li>
<li>
Insert a 14 gauge, _ inch guide needle through the desensitized skin at each of the sites.
</li>
<li>
Pass a 6 inch, 18 gauge needle through the guide needle and advance until the transverse process of the vertebra is felt.
</li>
<li>
Retract the needle and redirect cranially until the intertransverse ligament is identified.
</li>
<li>
Inject 15 mls of 2% lidocaine just below the intertransverse ligament at each of the 3 sites to block the ventral branches of nerves T13, L1 and L2.
</li>
<li>
Inject an additional 5 mls of 2% lidocaine proximal to the intertransverse ligament at each of the 3 sites to block the dorsal branches. 
</li>
<li>
#{LIMITS}  Paravertebral anesthesia may only be performed on <b>one side of a cow/day</b>. The cow must not be used again for at least <b>2 weeks</b>.
</li>
<li>
<b>Record procedure in animal's medical record.</b>
</li>
</ul>
"


EMBRYO_TRANSFER_CATTLE="
<b>Embryo Transfer (ET): Cattle</b>
<p>
Embryo Transfer consists of 4 phases:
</p>
<ol>
<li>
<b>Follicular Wave Synchronization</b>
<ul>
<li>
To remove the dominant follicle hormonally:
<ul>
<li>
Insert a CIDR (intravaginal progesterone releasing device) into the cow's vagina. At the same time, administer 100 ug of GnRH (2 mls of Cystorelin or Ovacyst) IM using an 18 gauge, 1.5 inch needle.
</li>
<li>
Initiate superovulation 3-6 days later.
</li>
</ul>
</li>
<li>
To remove the dominant follicle mechanically:
<ul>
<li>
Administer caudal epidural anesthesia:
<ul>
<li>
Clip the hair over the sacrococcygeal or first intercoccygeal space.
</li>
<li>
Aseptically prepare the site by scrubbing with surgical soap and rinsing with 70% alcohol.
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
</ul>
</li>
<li>
Tie the tail out of the way (to the cow).
</li>
<li>
Thoroughly clean the perineal area using soap and water.  
</li>
<li>
Insert the ultrasound probe specifically designed for aspiration into the vagina and advance to the fornix area.  
</li>
<li>
Move the ovary containing the dominant follicle close to the ultrasound probe via rectal palpation.
</li>
<li>
Use an 18 gauge, 2 inch needle to aspirate the follicle.
</li>
<li>
Initiate superovulation 2-4 days later.
</li>
</ul>
</li>
<li>
<b>Superovulation</b>
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
</li>
<li>
<b>Artificial Insemination</b>
<ul>
<li>
Artificially inseminate the cow 3 times at 12-hour intervals beginning at the first signs of heat (clear mucoid vaginal discharge, increased activity, bellowing, etc) 
<ul>
<li>
Clean the perineal area with surgical solution and rinse well.
</li>
<li>
Introduce the AI pipette into the vagina.
</li>
<li>
Grasp the cervix, per rectum, and pass the pipette into the uterus before infusing the semen.
</li>
</ul>
</li>
<li>
#{NOTE} If the animal kicks, vocalizes or shows more than momentary distress, the procedure must be immediately discontinued and not attempted again the same day. If blood is observed on the sleeve or pipette, the procedure must be immediately stopped and not attempted again the same day Ask the supervising veterinarian to assess the animal's condition. 
</li>
</ul>
</li>
<li>
<b>Embryo Flush</b>
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
</li>
</ul>
"

ASPIRATION_CATTLE="
<b>Follicular Aspiration for In-Vitro Fertilization: Cattle</b>
<ul>
<li>
Administer caudal epidural anesthesia
<ul>
<li>
Clip the hair over the sacrococcygeal or first intercoccygeal space.
</li>
<li>
Aseptically prepare the site by scrubbing with surgical soap and rinsing with 70% alcohol.
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
Thoroughly clean the perineal area using soap and water.  
</li>
<li>
Insert the ultrasound probe specifically designed for aspiration into the vagina and advance to the fornix area.  
</li>
<li>
Move the ovary containing the dominant follicle close to the ultrasound probe via rectal palpation.
</li>
<li>
Use an 18 gauge, 2 inch needle to aspirate the follicle and collect the oocytes.
</li>
<li>
#{LIMITS} Follicular aspiration may be performed in conjunction with superovulation or without superovulation.  Without superovulation, the oocytes may be harvested <b>once or twice a week for up to 6 consecutive weeks</b>. After a period of oocyte collection, the animal must have a <b>rest period that is not less than the duration of the harvesting period</b>.
</li>
<li>
#{NOTE} If blood is observed on the rectal sleeve at any time, the procedure in progress must be discontinued.
</li>
</ul>
"

RESTRAINT_HORSES = "
<b>Restraint and Handling: Horses</b>
<li>
The following may be used and/or demonstrated: 
<ul>
Horses may be restrained in stocks, cross-tied, or manually restrained.
</li>
<li>
Horses may be led by halter/lead rope or herded.
</li>
<li>
A twitch or breeding hobbles may be applied.
</li>
</ul>
</li>
</ul>
"
HOOF_EXAM_HORSES="
<b>Hoof Examination and Hoof Care: Horses</b>
<ul>
<li>
Hooves may be lifted, examined, cleaned and trimmed.
</li>
<li>
Shoes may be applied or removed.
</li>
</ul>
"

JUGULAR_VENIPUNCTURE_HORSES="
<b>Venipuncture - Jugular Vein: Horses</b>
<ul>
<li>
Use an 18-20 gauge needle.
</li>
<li>
Collect <b>up to 12 mls</b> of blood in a vacutainer tube or syringe.
</li>
<li>
#{LIMITS} Blood may be collected <b>no more than twice per side</b> on a given animal in a given laboratory and <b>no more frequently than twice per week</b>.
<ul>
<li>
<b>Mark animals with chalk or paint stick</b> each time venipuncture is performed so that limits are not exceeded.
</li>
</ul>
</li>
</ul>
"

NASOGASTRIC_INTUBATION_HORSES="
<b>Nasogastric Intubation (Stomach Tubing): Horses</b>
<ul>
<li>
Pass a lubricated stomach tube into the stomach via the nose.
</li>
</ul>
"

INJECTION_TECHNIQUES_HORSES="
<b>Injection Techniques: Horses </b>
<ul>
<li>
The following injection techniques may be demonstrated or performed: SQ, IM, IV.
</li>
<li>
Clean skin with alcohol.
</li>
<li>
Use a 20 gauge needle.
</li>
<li>
Inject no solution or up to <b>5 mls</b> of sterile saline solution per site.
</li>
<li>
Limits: Injections may be given no <b>more than twice/animal</b> in a given lab and <b>no more frequently than twice/week</b>. 
<ul>
<li>
<b>Mark animal with chalk or paint stick</b> each time an injection is performed so that limits are not exceeded.
</li>
</ul>
</li>
</ul>
"

REPRO_ULTRASOUND_HORSES="
<b>Reproductive Tract Palpation and Ultrasound Examination per Rectum: Horses </b>
<ul>
<li>
Don a lubricated rectal sleeve.
</li>
<li>
Infuse rectum with lubricant before inserting arm +/- ultrasound probe.
</li>
<li>
Clean rectum of feces by hand.
</li>
<li>
Palpate the tract and/or use an ultrasound probe to visualize the tract.
</li>
<li>
#{NOTE} If blood is observed on the rectal sleeve, the procedure must be immediately stopped. If the animal kicks, vocalizes or shows more than momentary distress when the arm/probe is inserted, the procedure must be immediately stopped and not attempted again the same day. Ask the supervising veterinarian to assess the animal’s condition. 
</ul>
"

ORAL_MEDICATION_HORSES="
<b>Administration of Oral Medication: Horses</b>
<ul>
<li>
• A dose syringe may be used to administer saline or water directly into the mouth.
</li>
<li>
• Equipment may simply be placed in the mouth without administering fluid.
</li>
</ul>
"

VAGINAL_SPECULUM_HORSES="
<b>Vaginal Speculum Examination: Horses </b>
<ul>
<li>
Clean the perineal area with surgical solution and rinse.
</li>
<li>
Apply lubricant to an appropriately sized sterile speculum.
</li>
<li>
 Insert the speculum through the vulva into the vaginal vault.
</li>
<li>
Visualize the cervix and vagina through the speculum using an external light source.
</li>
<li>
#{NOTE}  If the animal shows more than momentary distress when the speculum is inserted, the procedure must be immediately discontinued and not attempted again the same day.  If blood is observed on the speculum, the procedure must be immediately stopped and not attempted again the same day. Ask the supervising veterinarian to assess the animal’s condition. .
</li>
</ul>
"

end
