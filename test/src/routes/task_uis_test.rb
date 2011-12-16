require './test/testutil/requires'
require './src/routes/base'
require 'ostruct'
require './src/db/full_reservation'
require './src/functional/functionally'
require './strangled-src/model/requires'

class TaskUITests < RackTestTestCase
  include JsonHelpers

  def setup
    super
    real_controller.override(mocks(:renderer))
    @reservation = Reservation.random
  end

  context "adding notes to reservations" do
    should "begin with a page containing the reservation and a next step" do
      during {
        get Href::Reservation.note_editor_generator(@reservation.id)
      }.behold! {
        @renderer.should_receive(:render_page).once.
                  with(:reservation__note_editor,
                       :reservation => @reservation,
                       :fulfillment => Href::Reservation.note_link(@reservation.id,
                                                                "fulfillment"))
      }
    end
  end

  context "replicating reservations" do
    should "begin with a page containing the reservation and a next step" do 
      during {
        get Href::Reservation.repetition_adder_generator(@reservation.id)
      }.behold! {
        @renderer.should_receive(:render_page).once.
        with(:reservation__repetition_adder,
             :reservation => @reservation,
             :fulfillment => Href::Reservation.repetitions_link(@reservation.id,
                                                                "fulfillment"))
      }
    end
  end
end
