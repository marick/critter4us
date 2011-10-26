require './src/db/database_structure'
require './src/functional/functional_hash'
require './strangled-src/util/test-support'


class FullReservation < FunctionalHash
  self.extend(FHUtil)
  include TestSupport
  include DatabaseStructure

  def initialize(*args)
    super
    collaborators_start_as(:timeslice_source => FunctionalTimeslice)
  end

  def self.from_id(reservation_id)
    new(:starting_id => reservation_id,
        :data => lambda { | instance |
          Fonly(ReservationTable.filter(:id => instance.starting_id).all)
        },
        :groups => lambda { | instance | 
          Fall(GroupTable.filter(:reservation_id => instance.starting_id).all)
        },
        :uses => lambda { | instance |
          Fall(UsesTable.join_with_names.
                         filter_by_groups(instance.groups).
                         select(*UsesTable.columns_and_names).all)
        })
    end

  def with_changed_timeslice(timeslice)
    change_within(:data, :first_date, timeslice.first_date).
      change_within(:data, :last_date, timeslice.last_date).
      change_within(:data, :time_bits, timeslice.time_bits).
      remove_within(:data, :id)
  end

  def without_excluded_animals
    timeslice = @timeslice_source.from_reservation(self)
    with_markings = timeslice.mark_excluded_uses(self.uses)
    uses_to_discard, uses_to_keep = with_markings.partition(&:should_be_excluded)
    self.merge(uses: uses_to_keep,
               animals_with_scheduling_conflicts: uses_to_discard.map(&:animal_name).uniq)
  end

  def as_saved
    new_id = ReservationTable.insert(self.data - :id)
    self.groups.each do | group |
      group_id = GroupTable.insert(group - :id + {reservation_id: new_id })
      new_uses = uses.select { | use | use.group_id == group.id }.map do | use |
        use.only(:animal_id, :procedure_id) + {group_id: group_id}
      end
      UsesTable.multi_insert(new_uses)
    end
    self.class.from_id(new_id)
  end
end
