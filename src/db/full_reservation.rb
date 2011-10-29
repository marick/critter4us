require './src/db/db_hash'

class FullReservation < DBHash
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

  def my_timeslice
    @timeslice_source.from_reservation(self)
  end
    
  def partition_and_record(excluded_values, use_property, recording_symbol, recorded_property)
    excluded_values = Set.new(excluded_values)
    uses_to_discard, uses_to_keep = uses.partition do | u |
      excluded_values.include?(use_property.(u))
    end
    self.merge(:uses => uses_to_keep,
               recording_symbol => uses_to_discard.map(&recorded_property).uniq)
  end

  def without_animals_in_use
    partition_and_record(my_timeslice.animal_ids_in_use,
                         ->use {use.animal_id},
                         :animals_already_in_use,
                         ->use {use.animal_name})
  end

  def without_blacked_out_use_pairs
    partition_and_record(my_timeslice.use_pairs_blacked_out,
                         ->use {use.only(:animal_id, :procedure_id) },
                         :blacked_out_use_pairs, 
                         ->use {use.only(:animal_name, :procedure_name) })
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
