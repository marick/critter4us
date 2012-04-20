module Href

  def self.link(uri, relationship)
    {:href => uri, :rel => relationship}
  end    

  module Reservation
    def self.uris(subpart)
      defs =  %Q{def #{subpart}_raw(interpolation)
                   "/2/reservations/\#{interpolation}/#{subpart}"
                 end
                 def #{subpart}_match
                   #{subpart}_raw(:reservation_id.inspect)
                 end
                 def #{subpart}_generator(reservation_id)
                   #{subpart}_raw(reservation_id)
                 end
                 def #{subpart}_link(reservation_id, relationship)
                   Href.link(#{subpart}_generator(reservation_id), relationship)
                 end
               }
     instance_eval(defs)
    end

    uris("note")
    uris("repetitions")
    uris("note_editor")
    uris("repetition_adder")

    # OLD
    def self.list_match
      '/reservations/:days'
    end
  end

  # OLD
  def self.reservation_viewing_page(reservation_id)
    "/reservation/#{reservation_id}"
  end
end
