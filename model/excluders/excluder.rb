require 'util/requires'
require 'model/excluders/requires'

class Excluder < ExcluderShape
  include TestSupport

  def initialize(timeslice)
    super
    @currently_reserved = ReservedAnimalExcluder.new(@timeslice)
    @in_blackout_period = ProcedureBlackoutPeriodExcluder.new(@timeslice)
    @procedure_animal_conflict = ConflictingAnimalExcluder.new(@timeslice)
  end

  def time_sensitive_exclusions
    add(@in_blackout_period.as_map, @currently_reserved.as_map)
  end

  def timeless_exclusions
    @procedure_animal_conflict.as_map
  end
end
