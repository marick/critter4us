require 'model/reservation-base'

class ReservationMaker < ReservationBase
  def self.build_from(data)
    instance = new(data)
    instance.create_with_direct_data
    instance.add_groups
    instance.reservation
  end

  def create_with_direct_data
    @reservation = Reservation.create(@reservation_part)
  end
end
