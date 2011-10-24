require './src/functional/functional_hash'


class FullReservation < FunctionalHash
  self.extend(FHUtil)

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
end
