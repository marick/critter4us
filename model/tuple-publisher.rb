require 'model/query-maker'

class TuplePublisher
  include TestSupport

  def note_reservation_exclusions(reservation)
    reservation.uses.each do | use | 
      animal = use.animal
      procedure = use.procedure

      DB[:excluded_because_in_use].insert(:first_date => reservation.first_date,
                                          :last_date => reservation.last_date,
                                          :time_bits => reservation.time_bits,
                                          :reservation_id => reservation.id,
                                          :animal_id => animal.id)

      next if procedure.days_delay == 0 

      DB[:excluded_because_of_blackout_period].insert(
             :first_date => reservation.first_date - procedure.days_delay + 1,
             :last_date => reservation.last_date + procedure.days_delay - 1,
             :time_bits => reservation.time_bits,
             :reservation_id => reservation.id,
             :animal_id => animal.id,
             :procedure_id => procedure.id)
    end
  end
end
