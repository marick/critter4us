require './strangled-src/util/constants'
require './strangled-src/model/requires'
require 'pp'

class TransabdominalCorrection018 < Sequel::Migration

  def procedure
    Procedure[:name => "transabdominal ultrasonography"]
  end

  def up
    puts "==== fixing transabdominal ultrasound"
    DB[:exclusion_rules].filter(:procedure_id => procedure.id).delete
    Procedure.recalculate_exclusions
  end

  def down
    puts "==== unfixing transabdominal ultrasound"
    DB[:exclusion_rules].insert(:procedure_id => procedure.id,
                                :rule => "GoatsOnly")
    Procedure.recalculate_exclusions
  end
end
