require 'util/requires'

class Timeslice
  include TestSupport

  def initialize(mocks = {})
    collaborators_start_as(:use_source => Use,
                           :procedure_source => Procedure,
                           :hash_maker => HashMaker.new).unless_overridden_by(mocks)
  end

  def move_to(date, morning)
    @date = date
    @morning = morning
  end

  def exclusions
    procedures = procedure_source.names
    pairs = use_source.combos_unavailable_at(@date, @morning)
    hash_maker.keys_and_pairs(procedures, pairs)
  end

  def available_animals_by_name
    Animal.names.sort
  end

end
