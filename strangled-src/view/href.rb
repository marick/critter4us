module Href
  def self.reservation_note_raw(value)
    "/2/reservation/#{value}/note"
  end
  
  def self.reservation_note(reservation_id)
    CritterLogger.info reservation_id
    reservation_note_raw(reservation_id)
  end

  def self.reservation_note_route(key)
    reservation_note_raw(key.inspect)
  end


  def self.reservation_viewing_page(reservation_id)
    "/reservation/#{reservation_id}"
  end


  # TODO: These repetitive blocks of code should be consolidated into a 
  # class 'maker' method.
  def self.schedule_reservations_page_raw(value)
    "/2/reservation/#{value}/schedule"
  end
  
  def self.schedule_reservations_page(reservation_id)
    schedule_reservations_page_raw(reservation_id)
  end

  def self.schedule_reservations_page_route(key)
    schedule_reservations_page_raw(key.inspect)
  end
end
