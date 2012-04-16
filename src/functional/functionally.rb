require 'stunted'

module Functionally

  def self.copy_to_timeslice(reservation, timeslice)
    new_reservation =
      reservation.
      with_changed_timeslice(timeslice).
      without_animals_in_use.
      without_blacked_out_use_pairs.
      as_saved
    new_reservation.
      only(:animals_already_in_use, :blacked_out_use_pairs).
      merge(reservation_id: new_reservation.data.id)
  end
end

  def self.copy_to_timeslice(reservation, timeslice)
    new_reservation =
      flow(reservation,
           [with_changed_timeslice, timeslice],
           without_animals_in_use,
           without_blacked_out_use_pairs,
           as_saved)
  end
