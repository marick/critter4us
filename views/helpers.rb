module Helpers
  module Reservation
    def time_of_day(reservation)
      result = []
      result << MORNING if reservation.uses_morning?
      result << AFTERNOON if reservation.uses_afternoon?
      result << EVENING if reservation.uses_evening?
      result.join(', ')
    end

    def textile_note(reservation)
      RedCloth.new(reservation.note).to_html
    end

  end
end
