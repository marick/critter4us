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
    should "GET should pass the reservation to a view" do
      during {
        get Href::Reservation.note_editor_generator(@reservation.id)
      }.behold! {
        @renderer.should_receive(:render_page).once.
                  with(:reservation__note_editor, :reservation => @reservation)
      }
    end
  end

  context "scheduling further reservations by example" do
    context "GET" do 
      should_eventually "produce a page containing the reservation" do 
        during {
          get Href::Reservation.repetition_adder_generator(@reservation.id)
        }.behold! {
          @renderer.should_receive(:render_page).once.
          with(:reservation__repetition_adder, :reservation => @reservation)
        }
      end
    end

  end
end
