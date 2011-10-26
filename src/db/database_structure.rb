module DatabaseStructure
  ReservationTable = DB[:reservations]
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

end
