require './strangled-src/util/constants'
require './strangled-src/model/requires'
require 'pp'

class AllowHorses012 < Sequel::Migration

  def up
    puts "==== allowing horses to use formerly cattle procedures"
    embryo = Procedure[:name => "embryo transfer (cattle)"]
    follicular = Procedure[:name => "follicular aspiration (IVF)"]
    superovulation = Procedure[:name => "superovulation (cattle)"]

    embryo.name = "embryo transfer"; embryo.save
    superovulation.name = "superovulation"; superovulation.save

    [embryo, follicular, superovulation].each do | procedure |
      puts procedure
      DB[:exclusion_rules].filter(:procedure_id => procedure.id).delete
      description = ProcedureDescription.filter(:procedure => procedure).first
      description.animal_kind = "any species"
      description.description = description.description.sub(/: Cattle/, ": All Species")
      description.save
    end

    Procedure.recalculate_exclusions
  end

  def down
    puts "==== un-allowing horses to use formerly cattle procedures"
    throw "NOT DONE"
    Procedure.recalculate_exclusions
  end
end
