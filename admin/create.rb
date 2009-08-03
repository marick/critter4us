require 'rubygems' 
require 'path-setting'

require 'json' 
require 'sinatra/base'

Sinatra::Base.set :environment, :development
require 'config'
require 'admin/tables'
create_tables
require 'model'

TWICE_A_WEEK=3
TWO_WEEKS=14
ONCE_A_MONTH=30
EVERY_TWO_MONTHS=60


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




Animal.create(:name => 'brooke', :kind => 'bovine cow')
Animal.create(:name => 'genesis', :kind => 'equine gelding')
Animal.create(:name => 'sunny', :kind => 'equine mare')
Animal.create(:name => 'pumpkin', :kind => 'equine mare')



#
#
#
#




bossy = Animal[:name => 'bossy']
betsy = Animal[:name => 'betsy']
suzy = Animal[:name => 'suzy']
procedure = Procedure[:name => 'venipuncture']

Use.create(:animal => bossy, :procedure => procedure, :date => Date.today - 3)
Use.create(:animal => suzy, :procedure => procedure, :date => Date.new(1969))
Use.create(:animal => betsy, :procedure => procedure, :date => Date.today - 30)

puts procedure.uses_dataset.filter(:date => (Date.new(1969)..(Date.today-14))).inspect

procedure.uses_dataset.filter(:date => (Date.new(1969)..(Date.today-14))).each do | x | 
  puts x.date
end



