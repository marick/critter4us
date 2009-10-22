require 'util/requires'

class Timeslice
  include TestSupport

  def initialize(mocks = {})
    collaborators_start_as(:use_source => Use,
                           :procedure_source => Procedure,
                           :animal_source => Animal,
                           :hash_maker => HashMaker.new).unless_overridden_by(mocks)
  end

  def move_to(date, morning)
    @date = date
    @morning = morning
  end

  puts "Timeslice#exclusions needs to go away"
  def exclusions(hash = {})
    allowed_animals = hash[:allowing_animals] || []
    procedures = procedure_source.names
    pairs = use_source.combos_unavailable_at(@date, @morning)
    hash_maker.keys_and_pairs(procedures, remove_allowed_pairs(pairs, allowed_animals))
  end


  def add_excluded_pairs(pairs)
    procedures = procedure_source.names
    pairs += use_source.combos_unavailable_at(@date, @morning)
  end


  def available_animals_by_name
    use_source.remove_names_for_animals_in_use(animal_source.sorted_names,
                                               @date, @morning)
  end

  private

  def remove_allowed_pairs(pairs, allowed_animals)
    pairs.find_all do | procedure, animal |
      not (allowed_animals.include?(animal))
    end
  end

end
