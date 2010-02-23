require 'util/requires'
require 'model/excluders/requires'

class Excluder < ExcluderShape
  include TestSupport

  def initialize
    super
    @currently_reserved = ReservedAnimalExcluder.new
    @in_blackout_period = ProcedureBlackoutPeriodExcluder.new
    @procedure_animal_conflict = ConflictingAnimalExcluder.new
  end

  def time_sensitive_exclusions(timeslice)
    add(@in_blackout_period.as_map(timeslice), 
        @currently_reserved.as_map(timeslice))
  end

  def timeless_exclusions(timeslice)
    @procedure_animal_conflict.as_map(timeslice)
  end
end
