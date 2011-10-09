module Href
  def self.note_editing_page_raw(value)
    "/2/reservation/#{value}/note"
  end
  
  def self.note_editing_page(reservation)
    note_editing_page_raw(reservation.id)
  end

  def self.note_editing_page_route(key)
    note_editing_page_raw(key.inspect)
  end

  def self.reservation_viewing_page(reservation)
    "/reservation/#{reservation.id}"
  end
end
