module DBHelpers
  def insert_tuple(table, overrides = {})

    defaults = {
      :first_date => Date.new(2009,1,1),
      :last_date => Date.new(2009, 10, 10),
      :time_bits => "001",
    }

    unless overrides.has_key?(:animal_id)
      defaults[:animal_id] = Animal.random(:name => "unimportant animal").id
    end
    unless overrides.has_key?(:reservation_id)
      defaults[:reservation_id] = Reservation.random.id 
    end

    DB[table].insert(defaults.merge(overrides))
  end
end
