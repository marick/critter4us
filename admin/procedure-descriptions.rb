# -*- coding: utf-8 -*-
# WARNING:
#
#
#
# This is now defunct except for the text of the descriptions.
#
#
# WARNING

unless $in_rake 
  require 'rubygems'
  require 'path-setting'
  require 'config'
end
require 'model/requires'
require 'model/rules'

class ProcedureDescriptionSetter

  def describe_procedures
    DB[:procedure_descriptions].delete
    DB[:exclusion_rules].delete

    # ABDOMINOCENTESIS
    describe_one('abdominocentesis') do 
      no_goats
      bovine(PERITONEAL_CATTLE)
      equine(PERITONEAL_HORSES)
    end

    # ACUPUNCTURE DEMONSTRATION
    describe_one("acupuncture demonstration (horses)") do 
      horses_only
      equine(ACUPUNCTURE_HORSES)
    end

    # ARTIFICIAL INSEMINATION
    describe_one('artificial insemination') do 
      bovine(AI_CATTLE)
      caprine(AI_GOATS)
      equine(AI_HORSES)
    end

    # BANDAGE PLACEMENT
    describe_one('bandage placement (horses)') do
      horses_only
      equine(BANDAGE_PLACEMENT_HORSES)
    end

    # BLOOD COLLECTION FOR TRANSFUSION
    describe_one('blood collection for transfusion') do 
      no_goats
      bovine(BLOOD_COLLECTION_FOR_TRANSFUSION_CATTLE)
      equine(BLOOD_COLLECTION_HORSES)
    end

    # CASLICK'S OPERATION
    describe_one("Caslick's operation (horses)") do
      horses_only
      equine(CASLICKS_HORSES)
    end

    # CAUDAL EPIDURAL
    describe_one('caudal epidural (cattle)') do
      bovine_only
      bovine(CAUDAL_EPIDURAL_CATTLE)
    end

    # CHIROPRACTICE DEMONSTRATION
    describe_one("chiropractic demonstration (horses)") do 
      horses_only
      equine(CHIROPRACTIC_HORSES)
    end

    # CSF COLLECTION (LUMBOSACRAL)
    describe_one('CSF collection (lumbosacral)') do
      bovine_only
      bovine(CSF_CATTLE)
    end

    # EMBRYO TRANSFER
    describe_one('embryo transfer (cattle)') do
      bovine_only
      bovine(EMBRYO_TRANSFER_CATTLE)
    end

    # FLOATING TEETH
    describe_one("floating teeth (horses)") do
      horses_only
      equine(FLOATING_HORSES)
    end

    # FOLLICULAR ASPIRATION (IVF)
    describe_one('follicular aspiration (IVF)') do
      bovine_only
      bovine(ASPIRATION_CATTLE)
    end

    # HOOF EXAM AND CARE
    describe_one("hoof exam and care") do 
      bovine(HOOF_EXAM_CATTLE)
      caprine(HOOF_EXAM_GOATS)
      equine(HOOF_EXAM_HORSES)
    end

    # INJECTION (IM, SQ, IV)
    describe_one("injection (IM, SQ, IV)") do 
      bovine(INJECTION_TECHNIQUE_CATTLE)
      caprine(INJECTION_TECHNIQUE_GOATS)
      equine(INJECTION_TECHNIQUES_HORSES)
    end

    # IV CATHETER PLACEMENT

    describe_one('IV catheter placement (cattle)') do
      bovine_only
      bovine(IV_CATHETER_PLACEMENT_CATTLE)
    end

    # JUGULAR VENIPUNCTURE

    describe_one("jugular venipuncture") do 
      bovine(JUGULAR_VENIPUNCTURE_CATTLE)
      caprine(VENIPUNCTURE_JUGULAR_GOATS)
      equine(JUGULAR_VENIPUNCTURE_HORSES)
    end

    # LEG WRAPPING
    describe_one("leg wrapping (horses)") do
      horses_only
      equine(LEG_WRAPPING_HORSES)
    end

    # MILK COLLECTION
    describe_one("milk collection") do
      ruminants_only
      bovine(MILK_COLLECTION_CATTLE)
      caprine(MILK_COLLECTION_GOATS)
    end

    # MRI
    describe_one("MRI (horses)") do
      horses_only
      equine(MRI_HORSES)
    end

    # NASOGASTRIC INTUBATION

    describe_one('nasogastric intubation (horses)') do
      horses_only
      equine(NASOGASTRIC_INTUBATION_HORSES)
    end

    # NASOLACRIMAL DUCT FLUSHING
    describe_one("nasolacrimal duct flushing (horses)") do
      horses_only
      equine(NOSE_FLUSH_HORSES)
    end

    # OPTHALMIC EXAM
    describe_one("opthalmic examination") do 
      bovine(OPTHALMIC_CATTLE)
      caprine(OPTHALMIC_GOATS)
      equine(OPTHALMIC_HORSES)
    end

    # ORAL MEDICATION
    describe_one("oral medication") do 
      bovine(ORAL_MEDICATION_CATTLE)
      caprine(ORAL_MEDICATION_GOATS)
      equine(ORAL_MEDICATION_HORSES)
    end

    # OROGASTRIC INTUBATION
    describe_one("orogastric intubation") do
      ruminants_only
      bovine(OROGASTRIC_INTUBATION_CATTLE)
      caprine(OROGASTRIC_GOAT)
    end

    # PARAVERTEBRAL ANESTHESIA
    describe_one('paravertebral anesthesia (cattle)') do
      bovine_only
      bovine(PARAVERTEBRAL_ANESTHESIA_CATTLE)
    end

    # PHYSICAL EXAM
    describe_one('physical examination') do 
      caprine(PHYSICAL_EXAM_GOATS)
      others(PHYSICAL_EXAM_ALL)
    end

    # RADIOLOGY
    describe_one("radiology") do
      horses_only
      equine(RADIOLOGY_HORSES)
    end

    # REPRODUCTIVE TRACT PALPATION
    describe_one("reproductive tract palpation") do 
      no_goats
      bovine(REPRO_ULTRASOUND_CATTLE)
      equine(REPRO_ULTRASOUND_HORSES)
    end

    # RESPONSE TO ANESTHETIC DRUGS
    describe_one("response to anesthetic drugs") do 
      all(ANESTHETIC_ALL)
    end

    # RESTRAINT AND HANDLING
    describe_one("restraint and handling") do 
      bovine(RESTRAINT_CATTLE)
      caprine(RESTRAINT_AND_HANDLING_GOATS)
      equine(RESTRAINT_HORSES)
    end

    # RUMEN FLUID COLLECTION (RUMENOCENTESIS)
    describe_one('rumen fluid collection (rumenocentesis)') do
      bovine_only
      bovine(RUMENOCENTESIS)
    end

    # RUMEN FLUID COLLECTION (TUBE)
    describe_one('rumen fluid collection (tube)') do
      bovine_only
      bovine(CANNULATED_RUMEN_CATTLE)
    end

    # SEMEN COLLECTION
    describe_one('semen collection') do 
      bovine(SEMEN_COLLECTION_CATTLE)
      caprine(SEMEN_COLLECTION_GOATS)
      equine(SEMEN_COLLECTION_HORSES)
    end

    # SUPERFICIAL PALPATION
    describe_one('superficial palpation') do   # SAME AS PHYSICAL EXAM
      caprine(PHYSICAL_EXAM_GOATS)
      others(PHYSICAL_EXAM_ALL)
    end

    # SUPERFICIAL ULTRASONOGRAPHY
    describe_one("superficial ultrasonography") do 
      all(SUPERFICIAL_ULTRASONOGRAPHY_ALL)
    end

    # SYNOVIAL FLUID COLLECTION
    describe_one("synovial fluid collection (horse)") do
      horses_only
      equine(SYNOVIAL_HORSES)
    end

    # TAIL VENIPUNCTURE
    describe_one("tail venipuncture (cows)") do
      bovine_only
      bovine(TAIL_VENIPUNCTURE_CATTLE)
    end

    # TEASING AND USE AS MOUNT MARE
    describe_one("teasing and use as mount mare") do
      horses_only
      equine(TEASING_HORSES)
    end

    # TRANSRECTAL ULTRASONOGRAPHY    # SAME AS REPRODUCTIVE TRACT PALPATION
    describe_one("transrectal ultrasonography") do 
      no_goats
      bovine(REPRO_ULTRASOUND_CATTLE)
      equine(REPRO_ULTRASOUND_HORSES)
    end

    # TRANSABDOMINAL ULTRASONOGRAPHY
    describe_one("transabdominal ultrasonography") do 
      goats_only
      caprine(TRANSABDOMINAL_GOATS)
    end

    # TRANSTRACHEAL WASH
    describe_one('transtracheal wash (cattle)') do 
      bovine_only
      bovine(TRANSTRACHEAL_FLUID_ASPIRATION_CATTLE)
    end

    # TREADMILL EXERCISE
    describe_one("treadmill exercise (horses)") do
      horses_only
      equine(TREADMILL_HORSES)
    end

    # URINE COLLECTION BY CATHETER
    describe_one('urine collection by catheter') do
      no_goats
      bovine(URINE_COLLECTION_FEMALE_CATTLE)
      equine(URINE_COLLECTION_HORSES)
    end

    # UTERINE BIOPSY and UTERINE CULTURE  (same description, recorded separately)
    describe_one('uterine biopsy') do 
      no_goats
      others(UTERINE_CULTURE_ALL)
    end

    describe_one('uterine culture') do 
      no_goats
      others(UTERINE_CULTURE_ALL)
    end

    # VAGINAL EXAMINATION (MANUAL)
    describe_one('vaginal examination (manual) (cows)') do
      bovine_only
      bovine(MANUAL_VAGINAL_EXAM_CATTLE)
    end

    # VANGINAL EXAMINATION (SPECULUM)
    describe_one('vaginal examination (speculum)') do  
      bovine(VAGINAL_SPECULUM_CATTLE)
      caprine(VAGINAL_SPECULUM_EXAM_GOATS)
      equine(VAGINAL_SPECULUM_HORSES)
    end
  end


  def describe_one(procedure_name)
    procedures = Procedure.filter(:name => procedure_name).all
    if procedures.empty? 
      STDERR.puts("No procedure '#{procedure_name}' to describe.")
      return
    elsif procedures.size > 1
      STDERR.puts("More than one procedure '#{procedure_name}' to describe.")
      return
    end
    @one_procedure = procedures.first
    yield
  end

  def no_goats; add_rule("NoGoats"); end
  def horses_only; add_rule("HorsesOnly"); end
  def goats_only; add_rule("GoatsOnly"); end
  def bovine_only; add_rule("BovineOnly"); end
  def ruminants_only; add_rule("RuminantsOnly"); end

  def add_rule(rule)
    DB[:exclusion_rules].insert(:procedure_id => @one_procedure.id,
                                :rule => rule)
  end

  def all(description); add_description(ProcedureDescription::CATCHALL_KIND, description); end
  alias_method :others, :all
  def bovine(description); add_description('bovine', description); end
  def caprine(description); add_description('caprine', description); end
  def equine(description); add_description('equine', description); end

  def add_description(animal_kind, description)
    ProcedureDescription.create(:procedure => @one_procedure,
                                :animal_kind => animal_kind,
                                :description => description)
  end

  # ================== TEXT

  LIMITS="<span style='color:red'><i>Limits:</i></span>"
  NOTE="<span style='color:red'>NOTE:</span>"
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
#{LIMITS} More than one culture, but only <b><i>one</i> biopsy</b> may be conducted on a given animal on a given day.  The biopsy must not be performed more than <b>twice/month</b> on a given animal and must be <b>recorded in the animal's medical record</b>.
</li>
</ul>
"

  RESTRAINT_AND_HANDLING_GOATS="
<b>Restraint and Handling: Goats</b>
<ul>
<li>
The following may be used and/or demonstrated: 
<ul>
<li>
Goats may be manually restrained.
</li>
<li>
Goats may be led by halter/lead rope or herded.
</li>
<li>
Goats may be restrained in a chute/stanchion or behind a gate or alleyway system
</li>
</ul>
</li>
</ul>
"

  PHYSICAL_EXAM_GOATS="
<b>Routine Physical Examination, Palpation of Superficial Structures and Identification of Procedural Landmarks: Goats</b>
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


  HOOF_EXAM_GOATS="
<b>Hoof Examination and Hoof Care: Goats</b>
<ul>
<li>
Hooves may be lifted, examined, cleaned and trimmed.
</li>
</ul>
"

  VENIPUNCTURE_JUGULAR_GOATS="
<b>Venipuncture – Jugular Vein: Goats</b>
<ul>
<li>
Use an 18-20 gauge needle.
</li>
<li>
Collect <b>up to 12 mls</b> of blood in a vacutainer tube or syringe.
</li>
<li>
#{LIMITS} Blood may be collected <b>no more than twice per side</b> on a given animal in a given laboratory and <b>no more frequently than twice per week</b>.
</li>
<li>
<b>Mark animals with chalk or paint stick</b> each time venipuncture is performed so that limits are not exceeded.
</li>
</ul>
"

  OROGASTRIC_GOAT="
<b>Orogastric Intubation (Stomach Tubing): Goats</b>
<ul>
<li>
Place a speculum in the mouth and pass a stomach tube through the speculum into the rumen.
</li>
</ul>
"

  INJECTION_TECHNIQUE_GOATS="
<b>Injection Techniques: Goats</b>
<ul>
<li>
The following injection techniques may be demonstrated or performed: SQ, IM, IV.
</li>
<li>
Use a 16-20 gauge needle depending on the size of the animal and the viscosity of fluid to be injected.
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

  ORAL_MEDICATION_GOATS="
<b>Administration of Oral Medication: Goats</b>
<ul>
<li>
• A dose syringe may be used to administer saline or water directly into the mouth.
</li>
<li>
• A balling gun or dosing forceps may be used to administer an empty gelatin capsule into the pharynx. 
</li>
<li>
• Equipment may simply be placed in the mouth without administering fluid or capsules.
</li>
</ul>

"

  MILK_COLLECTION_GOATS="
<b>Milk Collection: Goats</b>
<ul>
<li>
<b>Up to 20 mls</b> of milk may be removed from each teat, followed by spraying of the teat with an approved germicide.
</li>
</ul>
"

  TRANSABDOMINAL_GOATS="
<b>Transabdominal Ultrasound:  Goats</b>
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

  VAGINAL_SPECULUM_EXAM_GOATS="
<b>Vaginal Speculum Examination: Goats </b>
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
#{NOTE}  If the animal shows more than momentary distress when the speculum is inserted, the procedure must be immediately discontinued and not attempted again the same day.  If blood is observed on the speculum, the procedure must be immediately stopped and not attempted again the same day. Ask the supervising veterinarian to assess the animal's condition.
</li>
</ul>
"

  SEMEN_COLLECTION_GOATS="
<b>Semen Collection: Goats</b>
<ul>
<li>
Semen may be collected using an electroejaculator.
</li>
<li>
No tranquilization or sedation is usually needed, but bucks may be tranquilizied with 10-20 mg of acepromazine prior to electroejaculation to help with restraint.
</li>
<li>
#{LIMITS} Semen may be collected no more than <b>once/animal/lab</b> and <b>no more than twice weekly</b>.
</li>
</ul>
"

  AI_GOATS="
<b>Artificial Insemination (Nonsurgical AI): Goats</b>
<ul>
<li>
Clean the perineal area with surgical solution and rinse well.
</li>
<li>
Introduce a catheter or pipette into the vagina and the cervix using visual (speculum) or manual guidance.
</li>
<li>
Saline may be infused. 
</li>
<li>
#{LIMITS} AI attempts will be dependent on the response of the animal. 
</li>
<li>
#{NOTE} If blood is observed on the pipette/catheter, the procedure must be immediately stopped and not attempted again the same day. If the animal kicks, vocalizes or shows more than momentary distress when the arm is inserted, the procedure must be immediately discontinued and not attempted again the same day. Ask the supervising veterinarian to assess the animal's condition.
</li>
</ul>
"

  OPTHALMIC_GOATS="
<b>Ophthalmic Examination: Goats</b>
<ul>
<li>
Routine ophthalmic examination may be performed using a penlight or ophthalmoscope.
</li>
<li>
If mydriasis (dilation of the pupil) is required, this may be induced by topical application of Mydriacyl (1% tropicamide; 3 drops). Goats must be maintained indoors for at least 12 hours to ensure the effects of the mydriatic have completely resolved before being allowed to go outside. 
</li>
<li>
Intraocular pressure may be measured using a tonometer on the surface of the cornea.
</li>
<li>
The cornea may be stained using fluorescein dye.
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
<ul>
<li>
Infusing lubricant into the rectum is not necessary.
</li>
</ul>
<li>
Clean rectum of feces by hand.
</li>
<li>
Palpate the tract and/or use an ultrasound probe to visualize the tract.
</li>
<li>
#{NOTE} If blood is observed on the rectal sleeve, the procedure must be immediately stopped. If the animal kicks, vocalizes or shows more than momentary distress when the arm/probe is inserted, the procedure must be immediately stopped and not attempted again the same day. Ask the supervising veterinarian to assess the animal's condition. 
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
#{NOTE} If the animal shows more than momentary distress when the arm is inserted, the procedure must be immediately discontinued and not attempted again the same day.  If blood is observed on the sleeve, the procedure must be immediately stopped and not attempted again the same day. Ask the supervising veterinarian to assess the animal's condition. .
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
#{LIMITS} Participants may be allowed <b>up to 3 attempts</b> to obtain a sample provided the animal is tolerating the procedure well.  Only <b>one peritoneal fluid sample may be collected per animal per day</b>.  This procedure <b>must be recorded in the animal's medical record</b>. 
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
#{LIMITS} Only <b>one jugular vein</b> may be catheterized in a given cow on a given day.  This procedure <b>must be recorded in the animal's medical record</b>.  A cow may be catheterized no more frequently than <b>every two weeks</b> and only if there is <b>no evidence of phlebitis</b>.
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
<b>Record procedure and amount of blood collected in the animal's medical record.</b>
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
<b>Regional Anesthesia - Paravertebral Anesthesia: Cattle</b>
<ul>
<li>
For proximal paravertebral anesthesia:
<ul>
<li>
Clip hair from the skin over the lumbar transverse processes.
</li>
<li>
Aseptically prepare the site by scrubbing with surgical soap and rinsing with 70% alcohol.
</li>
<li>
Using a 20 gauge needle, inject 3 mls of 2% lidocaine subcutaneously 5 cm from the dorsal midline at each of the 3 nerve block sites (1st-3rd lumbar vertebrae).
</li>
<li>
Insert a 14 gauge, 1/2 inch guide needle through the desensitized skin at each of the sites.
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
</li>
<li>
For distal paravertebral anesthesia:
<ul>
<li>
 Clip the hair from the skin around the lumbar transverse processes.
</li>
<li>
Aseptically prepare the site by scrubbing with surgical soap and rinsing with 70% alcohol.
</li>
<li>
Using an 18 gauge needle, inject 15-20 mls of 2% lidocaine in a fan-shaped pattern 5 cm deep to the transverse processes of the 1st, 2nd and 4th lumbar vertebrae.
</li>
<li>
Using the same needle, inject 5-10 mls of 2% lidocaine dorsocaudal to each of the 3 vertebrae to block the dorsal branches.
</li>
<li>
Test the success of the block by inserting a 22 gauge needle through the skin and musculature of the flank 2 inches caudal to the last rib.
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
<li>
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
Clean skin with alcohol.
</li>
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
#{NOTE} If blood is observed on the rectal sleeve, the procedure must be immediately stopped. If the animal kicks, vocalizes or shows more than momentary distress when the arm/probe is inserted, the procedure must be immediately stopped and not attempted again the same day. Ask the supervising veterinarian to assess the animal's condition. 
</ul>
"

ORAL_MEDICATION_HORSES="
<b>Administration of Oral Medication: Horses</b>
<ul>
<li>
A dose syringe may be used to administer saline or water directly into the mouth.
</li>
<li>
Equipment may simply be placed in the mouth without administering fluid.
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
#{NOTE}  If the animal shows more than momentary distress when the speculum is inserted, the procedure must be immediately discontinued and not attempted again the same day.  If blood is observed on the speculum, the procedure must be immediately stopped and not attempted again the same day. Ask the supervising veterinarian to assess the animal's condition. .
</li>
</ul>
"

VAGINAL_SPECULUM_CATTLE="
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
#{NOTE}  If the animal shows more than momentary distress when the speculum is inserted, the procedure must be immediately discontinued and not attempted again the same day.  If blood is observed on the speculum, the procedure must be immediately stopped and not attempted again the same day. Ask the supervising veterinarian to assess the animal's condition. .
</li>
</ul>
"



OPTHALMIC_HORSES="
<b>Ophthalmic Examination: Horses</b>
<ul>
<li>
Complete ophthalmic examination may be performed on horses
</li>
<li>
An auriculopalpebral block may be performed to induce akinesis of the upper eyelid to facilitate the examination
<ul>
<li>
Identify the auriculopalpebral nerve as it passes over the zygomatic arch
</li>
<li>
Prepare a 5cm square site for injection by alternating betadine scrub followed by isopropyl alcohol repeated 3 times.
</li>
<li>
Introduce a needle (22g) over the auriculopalpebral nerve at the caudal aspect of zygomatic arch; aspirate before injecting (to avoid rostral auricular vein)
</li>
<li>
Inject 2.0 mls of 2% lidocaine in a fan-shaped manner.
</li>
</ul>
</li>
<li>
If mydriasis (dilation of the pupil) is required, it may be induced by topical application of Mydriacyl (1% tropicamide; 3 drops). 
<ul>
<li>
Horses must be maintained indoors for at least 12 hours to ensure that the effects of the mydriatic have completely resolved before they are allowed to go outside into the sunlight. 
</li>
<li>
An equine veterinarian listed on the protocol must inspect the pupillary light reflex the day following the procedure to ensure that all effects of the mydriatic have worn off.
</li>
</ul>

</li>
<li>
Intraocular pressure may be measured using a tonometer on the surface of the cornea.
</li>
<li>
The cornea may be stained using fluorescein dye.
</li>
</ul>
"

SYNOVIAL_HORSES="
<b>Synovial Fluid Collection: Horses</b>
<ul>
<li>
Horses should be sedated with <b>0.5 mg/kg of xylazine IV</b> or <b>0.02 mg/kg of detomidine IV</b>.
</li>
<li>
Clip the sample site. 
</li>
<li>
Scrub site with surgical soap and rinse with isopropyl alcohol or saline.
</li>
<li>
Inject 1-5 mls of 2% carbocaine subcutaneously at the site using a 22-gauge, 1-1.5 inch needle.
</li>
<li>
Use an 18-20 gauge, 1.5 inch needle to aspirate 1-5 mls of fluid from the joint.
</li>
<li>
#{LIMITS}  Students may be allowed up to <b>3 attempts</b> to obtain a sample provided the animal is tolerating the procedure well.  Only <b>one joint</b> may be tapped per animal per day.  The procedure (including location of joint) must be <b>recorded in the animal's medical record</b>. Horses must be allowed <b>at least 2 weeks</b> between sample collections and the <b>joints must be rotated</b>.  
</li>
<li>
#{NOTE} Joints must not be tapped if an animal is lame, exhibits pain on palpation of the joint or has skin or subcutaneous tissue abnormalities over the joint (except for diagnostic purposes).
</li>
</ul>
"
PERITONEAL_HORSES="
<b>Peritioneal Fluid Collection: Horses</b>
<ul>
<li>
Horses should be sedated with <b>0.5 mg/kg of xylazine IV</b> or <b>0.02 mg/kg of detomidine IV</b>.
</li>
<li>
Clip the sample site. 
</li>
<li>
Scrub site with surgical soap and rinse with isopropyl alcohol or saline.
</li>
<li>
Inject 1-5 mls of 2% carbocaine subcutaneously at the site using a 22-gauge, 1-1.5 inch needle.
</li>
<li>
Use an 18-20 gauge, 1.5 inch needle to aspirate 1-5 mls of peritoneal fluid.
</li>
<li>
#{LIMITS}  Students will be allowed up to <b>3 attempts</b> to obtain a sample provided the animal is tolerating the procedure well. The procedure must be <b>recorded in the animal's medical record</b>. Horses must be allowed <b>at least 2 weeks</b> between sample collections.  
</li>
</ul>
"

URINE_COLLECTION_HORSES="
<b>Urine Collection via Urinary Catheter: Horses</b>
<ul>
<li>
Carefully wash and rinse the vulva or penis using surgical soap and sterile saline.
</li>
<li>
Use aseptic techniques to pass a sterile urinary catheter through the urethra and into the bladder.
</li>
</ul>
"

BLOOD_COLLECTION_HORSES="
<b>Blood Collection for Transfusion: Horses</b>
<ul>
<li>
A pre-collection PCV and total plasma protein concentration should be determined to assure the horse is a good candidate for blood donation.
</li>
<li>
Using standard human blood bags, aseptically collect blood from the jugular vein. The quantity collected will depend on the size of the recipient animal. From <b>1-8 liters</b> may be collected from a 450kg horse (<17% of its blood volume).  
</li>
<li>
The amount of blood that is removed must be replaced with an equal quantity of intravenous fluids.  
</li>
<li>
#{LIMITS}  The frequency of sampling should not exceed <b>6 times per year</b> per horse.
</li>
<li>
#{NOTE} Blood collection must ALWAYS be monitored by a senior faculty member who will develop criteria to determine the animal’s tolerance for the volume of blood taken based on clinical response during collection (e.g., heart rate and respiratory rate). <b>Record procedure and amount of blood collected in the animal's medical record.</b>
</li>
</ul>
"

MRI_HORSES="
<b>MRI: Horses</b>
<ul>
<li>
Horses must be anesthetized for MRI.
</li>
<li>
Fast horse overnight.
</li>
<li>
Clip the site over the left or right jugular vein.
</li>
<li>
Aseptically prepare the site by scrubbing with surgical soap and rinsing with 70% alcohol.
</li>
<li>
Place a 14 gauge jugular catheter into the vein.  Suture in place.
</li>
<li>
Walk the horse to the anesthesia induction area.  Rinse out the horses mouth with water.
</li>
<li>
Sedate the horse with <b>0.4-0.8 mg/kg xylazine IV</b>.
</li>
<li>
Once sedated, induce the horse with <b>3 mls TKD/500 kg IV</b>. (TKD is 100mg/ml Telazol, 80 mg/ml ketamine, and 4mg/ml detomidine).
</li>
<li>
After induction, intubate the horse and maintain on isoflurane in 100% oxygen using a precision vaporizer on an MRI-compatible anesthesia machine (positive pressure ventilation should be available to maintain PaO2 and PaCO2 within normal limits).
</li>
<li>
Temporarily place a 20 gauge catheter into either the facial or metatarsal artery (depends on area to be imaged) to measure direct arterial blood pressure.
</li>
<li>
Monitor the horse using ECG, direct blood pressure, ETCO2 and SaO2.  Run arterial blood gases as needed.
</li>
<li>
Once the MRI is complete, remove the arterial catheter and move the horse to a padded recovery stall. 
</li>
<li>
 Extubate once swallowing reflexes return.
</li>
<li>
As needed, provide additional sedation (<b>50-100 mg xylazine</b>) in order to ensure a smooth recovery.
</li>
<li>
Once the horse has completely recovered, return it to its stall and remove the jugular catheter.
</li>
<li>
#{LIMITS} MRI may be done up to <b>two times per year</b> on a given horse.
</li>
<ul>

"

CHIROPRACTIC_HORSES="
<b>Chiropractic Demonstration: Horses</b>
<ul>
<li>
Chiropractic demonstrations must be performed by an experienced chiropractor in the exercise and/or treatment area of Ward 4.
</li>
<li>
Chiropractic procedures that may be demonstrated include manual manipulation of the horse's head, neck, back and extremities.
</li>
<li>
#{LIMITS} A horse may not be used more than <b>2 times per semester</b> or <b>4 times per academic year</b> for chiropractic demonstration.
</li>
</ul>
"

ACUPUNCTURE_HORSES="
<b>Acupuncture Demonstration: Horses</b>
<ul>
<li>
An experienced acupuncturist may perform acupuncture demonstrations in the exercise and/or treatment area of Ward 4.
</li>
<li>
Sterile acupuncture needles may be strategically placed in areas corresponding to acupuncture points.
</li>
<li>
#{LIMITS} A horse may not be used more than <b>2 times per semester</b> or <b>4 times per academic year</b> for chiropractic demonstration
</li>
</ul>
"

TREADMILL_HORSES="
<b>Treadmill Exercise: Horses</b>
<ul>
<li>
An EQMS faculty member may demonstrate treadmill exercise with the assistance of equine surgery residents, interns and/or veterinary students.
</li>
</ul>
"

NOSE_FLUSH_HORSES="
<b>Nasolacrimal Duct Flush: Horses</b>
<ul>
<li>
Place the tip of a sterile catheter into the punctal opening on the floor of the nostril.
</li>
<li>
Using a 12 ml syringe filled with eyewash or saline, flush solution gently through the catheter while the lower punctum is occluded with digital pressure.
</li>
<li>
Continue flushing until the solution exits the upper punctum near the medial canthus.
</li>
</ul>
"

FLOATING_HORSES="
<b>Floating (Filing) of Teeth: Horses</b>
<ul>
<li>
Follow standard floating methods used for clinical patients.
</li>
</ul>
"

LEG_WRAPPING_HORSES="
<b>Leg Wrapping and Non-adhesive Distal Limb Bandaging: Horses</b>
<ul>
<li>
Follow standard bandaging methods used for clinical patients.
</li>
</ul>
"

AI_HORSES="
<b>Artificial Insemination (Nonsurgical AI): Horses</b>
<ul>
Clean the perineal area with surgical solution and rinse well.
</li>
<li>
Place a sleeved, lubricated arm directly into the vagina to guide the pipette through the cervix.
</li>
<li>
Saline may be infused. 
</li>
<li>
Stallion semen may be infused for the purpose of creating a pregnancy. 
<ul>
<li>
Should pregnancy occur, the conceptus must be aborted before 35 days of gestation using systemic prostaglandins [dinoprost tromethamine (5mg IM SID for 48 hours) or cloprostenol (250mcg IM)].	
</li>
<li>
A follow up ultrasound examination must be performed within 5 days after prostaglandin treatment to assure pregnancy has been terminated. 
</li>
</ul>
</li>
<li>
#{LIMITS} Artificial insemination may be conducted no more than <b>once/month</b> on a given mare. 
</li>
<li>
#{NOTE} If blood is observed on the sleeve or pipette/catheter, the procedure must be immediately stopped and not attempted again the same day. If the animal kicks, vocalizes or shows more than momentary distress when the arm is inserted, the procedure must be immediately discontinued and not attempted again the same day. Ask the supervising veterinarian to assess the animal's condition. 
</li>
</ul>
"

SEMEN_COLLECTION_HORSES="
<b>Semen Collection: Horses </b>
<ul>
<li>
Semen may be collected using an artificial vagina.
</li>
<li>
#{LIMITS} Semen may be collected no more than <b>once/animal/lab</b> and <b>no more than twice weekly</b>.
</li>
</ul>
"

TEASING_HORSES="
<b>Teasing and Use as a Mount Mare: Horses</b>
<ul>
<li>
Restrain mare with hobbles, a twitch, or sedation as needed to prevent her from kicking the stallion.
</li>
<li>
#{LIMITS} A mount mare may be used up to <b>twice/day</b> with an <b>interval of one hour</b> between stallion collections <b>or once daily for 3-5 days</b>. 
</li>
</ul>
"

RADIOLOGY_HORSES="
<b>Radiology: Horses</b>
<ul>
<li>
Horses may be used for student radiology wet labs, continuing education radiology labs for veterinary technicians and miscellaneous radiography procedures to produce films for other teaching purposes.
</li>
<li>
#{LIMITS}
<ul>
<li>
o In veterinary student wet labs, up to <b>two horses</b> may be subjected to up to <b>10 radiographs of the distal limbs once per year</b>.  
</li>
<li>
In veterinary technician labs, <b>one horse</b> may be subjected to radiographs of the <b>limbs, thorax and skull</b>.
</li>
<li>
Radiographs may be taken of the <b>limbs, thorax and skull</b> for other teaching purposes.
</li>
</ul>
</li>
<li>
#{NOTE} If sedation is necessary, administer <b>150mg of xylazine IV</b> or up to <b>0.5 ml of Dormosedan</b>. 
</li>
</ul>
"

BANDAGE_PLACEMENT_HORSES="
<b>Bandage Placement (Horses)</b>
<ul>
<li>
Apply bandages to limbs as for client animals.
</li>
</ul>
"
end

if $0 == __FILE__
  ProcedureDescriptionSetter.new.describe_procedures
  pp DB[:exclusion_rules].all

  DB[:procedure_descriptions].each do | desc | 
    procedure = DB[:procedures].filter(:id => desc[:procedure_id]).collect do | p | 
      p[:name]
    end
    puts "desc #{desc[:id]} is for #{procedure} / #{desc[:animal_kind]}"
  end
end
