module DatabaseStructure
  ReservationTable = DB[:reservations]
  class << ReservationTable
    include Stunted::FHUtil
    def all_with_unique_names
      # Note: left joins are done so that tests don't
      # have to set up the whole structure.
      dataset = select_append(:reservations__id.as(:pk)).
        left_join(:groups, :reservation_id => :reservations__id).
        left_join(:uses, :group_id => :groups__id).
        left_join(:procedures, :id => :uses__procedure_id).
        left_join(:animals, :id => :uses__animal_id).
        select_append(:procedures__name.as(:procedure_names)).
        select_append(:animals__name.as(:animal_names))

      dataset = yield(dataset) if block_given?

      Fall(dataset.all).segregate_by_key(:pk).collect do | reservation_rows |
        reservation_rows.collapse_and_aggregate(:animal_names, :procedure_names) do | a | 
          a.sort.uniq
        end
      end
    end

    def rows_back_to(date)
      all_with_unique_names do | dataset | 
        dataset.filter { | o | o.last_date >= date } 
      end
    end
  end

  GroupTable = DB[:groups]

  UsesTable = DB[:uses]
  class << UsesTable
    def columns; [ :procedure_id, :animal_id, :group_id, :uses__id ]; end

    def columns_and_names
      columns + 
      [:animals__name.as(:animal_name), :procedures__name.as(:procedure_name)]
    end

    def join_with_names
      self.join(:animals, :animals__id => :uses__animal_id).
           join(:procedures, :procedures__id => :uses__procedure_id)
    end

    def filter_by_groups(groups)
      filter(:group_id => groups.map(&:id))
    end
  end

  ExcludedBecauseInUse = DB[:excluded_because_in_use]
  ExcludedBecauseOfBlackoutPeriod = DB[:excluded_because_of_blackout_period]

end
