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
        get Href::Task_Uis.edit_reservation_note_generator(@reservation.id)
      }.behold! {
        @renderer.should_receive(:render_page).once.
                  with(:task_uis__reservation__edit_note, :reservation => @reservation)
      }
    end
  end

  context "scheduling further reservations by example" do
    context "GET" do 
      should "produce a page containing the reservation" do 
        during {
          get Href::Task_Uis.add_reservation_repetitions_generator(@reservation.id)
        }.behold! {
          @renderer.should_receive(:render_page).once.
          with(:task_uis__reservation__add_repetitions, :reservation => @reservation)
        }
      end
    end

  end
end
