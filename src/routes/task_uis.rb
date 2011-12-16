# -*- indent-tabs-mode: nil -*-

require './src/routes/base'
require './src/views/requires'

class Controller

  def with_reservation
    reservation_id = params[:reservation_id]
    yield reservation_source[reservation_id]
  end

  def render_with_reservation_fulfillment(page, fulfillment_link)
    with_reservation do | reservation | 
      link = Href::Reservation.send(fulfillment_link, reservation.id, "fulfillment")
      @renderer.render_page(page,
                            :reservation => reservation,
                            :fulfillment => link)
    end
  end

  get Href::Reservation.note_editor_match do
    render_with_reservation_fulfillment(:reservation__note_editor, :note_link)
  end

  get Href::Reservation.repetition_adder_match do
    render_with_reservation_fulfillment(:reservation__repetition_adder, :repetitions_link)
  end
end

