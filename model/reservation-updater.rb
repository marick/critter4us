require './model/reservation-base'

class ReservationUpdater < ReservationBase
  def self.update(reservation, data)
    instance = new(reservation, data)
    instance.update
  end

  def initialize(reservation, data)
    super(data)
    @reservation = reservation
  end

  def update
    destroy_groups
    update_direct_data
    add_groups
  end

  def destroy_groups
    @reservation.groups.each do | g |
      g.destroy
    end
    @reservation.remove_all_groups
  end

  def update_direct_data
    @reservation.update(@reservation_part)
  end
end

