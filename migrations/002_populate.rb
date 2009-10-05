require 'model/animal'
require 'model/procedure'

TWICE_A_WEEK=3
TWO_WEEKS=14
ONCE_A_MONTH=30
EVERY_TWO_MONTHS=60

class Population < Sequel::Migration

  def up
    puts '==== adding procedures and animals'
    puts '==== WARNING: For some reason, migrations 1 and 2 have to be run in separate invocations'
    puts "==== WARNING: If you see a failure now, that's why."
    Procedure.create(:name => 'restraint and handling', :days_delay => 0)
    Procedure.create(:name => 'physical examination', :days_delay => 0)
    Procedure.create(:name => 'superficial palpation', :days_delay => 0)
    Procedure.create(:name => 'superficial ultrasonography', :days_delay => 0)
    Procedure.create(:name => 'hoof exam and care', :days_delay => 0)
    Procedure.create(:name => 'nasogastric intubation (horses)', :days_delay => 0)
    Procedure.create(:name => 'orogastric intubation (cows)', :days_delay => 0)
    Procedure.create(:name => 'oral medication', :days_delay => 0)

    Procedure.create(:name => 'injection (IM, SQ, IV)', :days_delay => TWICE_A_WEEK)
    # Twice per animal in lab.
    Procedure.create(:name => 'jugular venipuncture', :days_delay => TWICE_A_WEEK)
    # Twice per side per animal in a lab.
    Procedure.create(:name => 'tail venipuncture (cows)', :days_delay => TWICE_A_WEEK)
    # Twice per lab.
    Procedure.create(:name => 'response to anesthetic drugs', :days_delay => 0)
    Procedure.create(:name => 'nasolacrimal duct flushing (horses)', :days_delay => 0)
    Procedure.create(:name => 'floating teeth (horses)', :days_delay => 0)
    Procedure.create(:name => 'leg wrapping (horses)', :days_delay => 0)
    Procedure.create(:name => 'bandage placement (horses)', :days_delay => 0)
    Procedure.create(:name => 'milk collection (cows)', :days_delay => 0)
    Procedure.create(:name => 'reproductive tract palpation', :days_delay => 0)
    Procedure.create(:name => 'transrectal ultrasonography', :days_delay => 0)
    Procedure.create(:name => 'vaginal examination (speculum)', :days_delay => 0)
    Procedure.create(:name => 'vaginal examination (manual) (cows)', :days_delay => 0)
    Procedure.create(:name => 'uterine culture', :days_delay => 0)
    Procedure.create(:name => 'uterine biopsy', :days_delay => TWO_WEEKS)
    # No more than one per lab
    Procedure.create(:name => 'semen collection', :days_delay => TWICE_A_WEEK)
    # Once per lab
    Procedure.create(:name => 'artificial insemination', :days_delay => ONCE_A_MONTH)
    Procedure.create(:name => 'radiology', :days_delay => 0)
    Procedure.create(:name => 'opthalmic examination', :days_delay => TWICE_A_WEEK)
    Procedure.create(:name => 'synovial fluid collection (horse)', :days_delay => TWO_WEEKS)
    # No more than 3 x per lab on a single joint
    # Rotate joints on each lab
    Procedure.create(:name => 'abdominocentesis', :days_delay => TWO_WEEKS)
    # 3 times in a lab
    Procedure.create(:name => 'urine collection by catheter', :days_delay => 0)
    Procedure.create(:name => 'IV catheter placement (cattle)', :days_delay => TWO_WEEKS)
    # Once per cow per lab
    Procedure.create(:name => 'blood collection for transfusion', :days_delay => EVERY_TWO_MONTHS)
    Procedure.create(:name => 'transtracheal wash (cattle)', :days_delay => TWO_WEEKS)
    # Once per lab
    Procedure.create(:name => 'CSF collection (lumbosacral)', :days_delay => TWO_WEEKS)
    # Once per lab
    Procedure.create(:name => 'rumen fluid collection (tube)', :days_delay => 0)
    Procedure.create(:name => 'rumen fluid collection (rumenocentesis)', :days_delay => TWO_WEEKS)
    # No more than 3 X per lab
    Procedure.create(:name => 'MRI (horses)', :days_delay => 0)
    Procedure.create(:name => 'chiropractic demonstration (horses)', :days_delay => 60)
    Procedure.create(:name => 'acupuncture demonstration (horses)', :days_delay => 60)
    Procedure.create(:name => "Caslick's operation (horses)", :days_delay => 50000)
    Procedure.create(:name => 'caudal epidural (cattle)', :days_delay => 0)
    Procedure.create(:name => 'paravertebral anesthesia (cattle)', :days_delay => TWO_WEEKS)
    # once per cow per lab
    Procedure.create(:name => 'embryo transfer (cattle)', :days_delay => 21)
    # Procedure.create(:name => 'follicular aspiration (IVF)', :days_delay => COMPLICATED)
    Procedure.create(:name => 'treadmill exercise (horses)', :days_delay => 0)


    Animal.create(:name => 'All Star', :kind => 'stallion')
    Animal.create(:name => 'Genesis', :kind => 'gelding')
    Animal.create(:name => 'Pumpkin', :kind => 'mare')
    Animal.create(:name => 'Misty', :kind => 'mare')
    Animal.create(:name => 'Good Morning Sunshine', :kind => 'mare')
    Animal.create(:name => 'Boombird', :kind => 'mare')
    Animal.create(:name => 'Sunny', :kind => 'mare')
    Animal.create(:name => 'Brooke', :kind => 'cow')
    Animal.create(:name => '00078', :kind => 'cow')
    Animal.create(:name => '00153', :kind => 'cow')
    Animal.create(:name => '00912', :kind => 'cow')
    Animal.create(:name => '01441', :kind => 'cow')
    Animal.create(:name => '01788', :kind => 'cow')
    Animal.create(:name => '16167', :kind => 'cow')
    Animal.create(:name => '20429', :kind => 'cow')
    Animal.create(:name => '20834', :kind => 'cow')
    Animal.create(:name => '21126', :kind => 'cow')
    Animal.create(:name => '21251', :kind => 'cow')
    Animal.create(:name => '22617', :kind => 'cow')
    Animal.create(:name => '23261', :kind => 'cow')
    Animal.create(:name => '23267', :kind => 'cow')
    Animal.create(:name => '23551', :kind => 'cow')
    Animal.create(:name => '23940', :kind => 'cow')
    Animal.create(:name => '24435', :kind => 'cow')
    Animal.create(:name => '24447', :kind => 'cow')
    Animal.create(:name => '24605', :kind => 'cow')
    Animal.create(:name => '24638', :kind => 'cow')
    Animal.create(:name => '24711', :kind => 'cow')
    Animal.create(:name => '24794', :kind => 'cow')
    Animal.create(:name => '24881', :kind => 'cow')
    Animal.create(:name => '24883', :kind => 'cow')
  end

  def down
    puts "==== emptying procedure and animal tables"
    DB[:uses].delete
    DB[:groups].delete
    DB[:reservations].delete
    DB[:procedures].delete
    DB[:animals].delete
  end
end
