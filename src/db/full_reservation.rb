require './src/db/db_hash'
require './src/db/functional_timeslice'

class FullReservation < DBHash
  def initialize(*args)
    super
    collaborators_start_as(:timeslice_source => FunctionalTimeslice)
  end

  DATA_FETCHER = lambda { | instance |
    Fonly(ReservationTable.filter(:id => instance.starting_id).all)
  }
  GROUPS_FETCHER = lambda { | instance | 
    Fall(GroupTable.filter(:reservation_id => instance.starting_id).all)
  }
  USES_FETCHER = lambda { | instance |
    Fall(UsesTable.
         join_with_names.
         filter_by_groups(instance.groups).
         select(*UsesTable.columns_and_names).all)
  }
  
  def self.resets(reservation_id)
    { 
      :starting_id => reservation_id,
      :data => DATA_FETCHER,
      :groups => GROUPS_FETCHER,
      :uses => USES_FETCHER
    }
  end

  def self.from_id(reservation_id)
    new(resets(reservation_id))
  end

  def with_changed_timeslice(timeslice)
    change_within(:data, timeslice).remove_within(:data, :id)
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

  def save!
    resulting_id = ReservationTable.insert(self.data - :id)
    self.groups.each do | group |
      group_id = GroupTable.insert(group - :id + {reservation_id: resulting_id })
      new_uses = uses.select { | use | use.group_id == group.id }.map do | use |
        use.only(:animal_id, :procedure_id) + {group_id: group_id}
      end
      UsesTable.multi_insert(new_uses)
    end
    resulting_id
  end

  def as_saved
    merge(self.class.resets(save!))
  end

  def animal_names 
    uses.collect(&:animal_name).uniq
  end

  def procedure_names 
    uses.collect(&:procedure_name).uniq
  end
end
