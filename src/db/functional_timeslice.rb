require './src/db/db_hash'

class FunctionalTimeslice < DBHash
  def self.from_browser(raw_data)
    data = JSON.parse(Base64.decode64(raw_data))
    from_time_data(Date.parse(data['first_date']), Date.parse(data['last_date']),
                   TimeSet.new(data['times']).bits)
  end

  def self.from_reservation(reservation)
    from_time_data(reservation.data.first_date, reservation.data.last_date,
                   reservation.data.time_bits)
  end

  def self.from_time_data(first_date, last_date, time_bits)
    self.new(:first_date => first_date,
             :last_date => last_date,
             :time_bits => time_bits)
  end

  def overlaps(dataset)
    Fall(dataset.filter("(DATE ?, DATE ?) OVERLAPS (first_date, last_date+1)",
                        self.first_date, self.last_date+1).
         filter("(B? & CAST(time_bits AS bit(3))) != B'000'", self.time_bits))
  end

  def animal_ids_in_use
    overlaps(ExcludedBecauseInUse).map(&:animal_id).uniq
  end

  def use_pairs_blacked_out
    overlaps(ExcludedBecauseOfBlackoutPeriod).map { | o | o.only(:animal_id, :procedure_id) }.uniq
  end

  def mark_excluded_uses(uses)
    animals_in_use = @exclusion_memory.animals_in_use(self)
    blacked_out_uses = @exclusion_memory.blacked_out_potential_uses(self)
    uses.collect do | use |
      should_be_excluded =
        animals_in_use.any? { | animal | animal.animal_id == use.animal_id } || 
        blacked_out_uses.any? { | blacked_out | use.animal_id == blacked_out.animal_id && 
                                                use.procedure_id == blacked_out.procedure_id }
      use + {should_be_excluded: should_be_excluded}
    end
  end
end
