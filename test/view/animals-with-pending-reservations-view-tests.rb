$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class AnimalsWithPendingReservationsViewTests < FreshDatabaseTestCase
  include ViewHelper
  include ErectorTestSupport

  def setup
    super
    @proposed_date = Date.new(2009,1,1)

    # And here are the interesting cases.

    # An animal with no reservations is not of interest to this table.
    Animal.random(:name => 'not reserved')

    # An animal with a reservation in the past is also of no interest.
    Reservation.random(:date => Date.new(2008, 1, 1)) do
      use Animal.random(:name => 'reserved in past')
      use Procedure.random
    end

    # Here are two animals with reservations in the future. They're
    # the only ones of interest.
    @far_future_reservation = Reservation.random(:date => Date.new(2019, 12, 13)) do
      use Animal.random(:name => 'far future')
      use Procedure.random
    end

    near_future = Animal.random(:name => 'Near future')
    @near_future_reservation = Reservation.random(:date => Date.new(2010, 1, 1)) do
      use near_future
      use Procedure.random
    end

    # Because this reservation is in the past, it should not 
    # show up in the table.
    Reservation.random(:date => Date.new(2008, 1, 1)) do
      use near_future
      use Procedure.random
    end

    @view = AnimalsWithPendingReservationsView.new(:animal_source => Animal,
                                                   :date => @proposed_date)
  end

  should "show animals with pending reservations" do 
    html = @view.to_s
    assert { html.include? 'far future' }
    assert { html.include? 'Near future' }
    deny { html.include? 'not reserved' }
    deny { html.include? 'reserved in past' }
  end

  should "sort animals by name" do
    html = @view.to_s
    assert { html.index("far future") < html.index("Near future") }
  end

  should "use a sub-widget to fill in the dates cell" do
    during { 
      @view.to_s
    }.behold! { 
      view_itself.should_use_widget(ReservationDatesCell).
                  handing_it(:reservations => [@far_future_reservation])
      view_itself.should_use_widget(ReservationDatesCell).
                  handing_it(:reservations => [@near_future_reservation])
    }
  end
end
