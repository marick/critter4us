require './src/functional/functional_hash'
require './strangled-src/util/test-support'


class FullReservation < FunctionalHash
  self.extend(FHUtil)
  include TestSupport

  def initialize(*args)
    super
    collaborators_start_as(:timeslice_source => FunctionalTimeslice)
  end

  def self.from_id(reservation_id)
    new(:starting_id => reservation_id,
        :data => lambda { | instance |
          Fonly(DB[:reservations].filter(:id => instance.starting_id))
        },
        :groups => lambda { | instance | 
          Fall(DB[:groups].filter(:reservation_id => instance.starting_id).all)
        },
        :uses => lambda { | instance |
          Fall(DB[:uses].
               join(:animals, :animals__id => :uses__animal_id).
               join(:procedures, :procedures__id => :uses__procedure_id).
               filter(:group_id => instance.groups.map(&:id)).
               select(:animals__name.as(:animal_name),
                      :procedures__name.as(:procedure_name),
                      :procedure_id, :animal_id, :group_id,
                      :uses__id))
        })
    end

  def with_changed_timeslice(timeslice)
    change_within(:data, :first_date, timeslice.first_date).
      change_within(:data, :last_date, timeslice.last_date).
      change_within(:data, :time_bits, timeslice.time_bits).
      remove_within(:data, :id)
  end

  def without_excluded_animals
    uses_to_discard, uses_to_keep = animals_to_discard_and_keep
    self.merge(uses: uses_to_keep,
               animals_with_scheduling_conflicts: uses_to_discard.map(&:animal_name).uniq)
  end

  def animals_to_discard_and_keep
    animals_excluded = @timeslice_source.from_reservation(self).animals_excluded_during
    bad_animal = lambda { | animal_id | animals_excluded.include?(animal_id) }
    uses.partition{ |use| bad_animal.(use.animal_id) }
  end

  def as_saved
    new_id = DB[:reservations].insert(self.data - :id)
    self.groups.each do | group |
      group_id = DB[:groups].insert(group - :id + {reservation_id: new_id })
      new_uses = uses.select { | use | use.group_id == group.id }.map do | use |
        use.only(:animal_id, :procedure_id) + {group_id: group_id}
      end
      DB[:uses].multi_insert(new_uses)
    end
    self.class.from_id(new_id)
  end
end
