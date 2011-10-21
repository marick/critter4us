require './test/testutil/requires'
require './strangled-src/model/requires'
require './strangled-src/view/requires'

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
    Reservation.random(:timeslice => Timeslice.random(:first_date => "2008-01-01",
                                                      :last_date => "2008-01-01"),
                       :animal => Animal.random(:name => 'reserved in past'),
                       :procedure => Procedure.random)

    # Here are two animals with reservations in the future. They're
    # the only ones of interest.
    @far_future_reservation = Reservation.random(:timeslice => 
                                                 Timeslice.random(:first_date => '2019-12-13',
                                                                  :last_date => '2019-12-13'),
                                                 :animal =>  Animal.random(:name => 'far future'),
                                                 :procedure => Procedure.random)

    near_future = Animal.random(:name => 'Near future')
    @near_future_reservation = Reservation.random(:timeslice =>
                                                  Timeslice.random(:first_date => '2010-01-01',
                                                                   :last_date => '2010-01-01'),
                                                  :animal => near_future,
                                                  :procedure => Procedure.random)

    # Because this reservation is in the past, it should not 
    # show up in the table.
    Reservation.random(:timeslice => Timeslice.random(:first_date => '2008-01-01',
                                                      :last_date => '2008-01-01'),
                       :animal => near_future,
                       :procedure => Procedure.random)

    @view = AnimalsWithPendingReservationsView.new(:animal_source => Animal,
                                                   :date => @proposed_date)
  end

  should "show animals with pending reservations" do 
    html = @view.to_html
    assert { html.include? 'far future' }
    assert { html.include? 'Near future' }
    deny { html.include? 'not reserved' }
    deny { html.include? 'reserved in past' }
  end

  should_eventually "sort animals by name" do
    html = @view.to_html
    assert { html.index("far future") < html.index("Near future") }
  end

  should "use a sub-widget to fill in the dates cell" do
    during { 
      @view.to_html
    }.behold! { 
      view_itself.should_use_widget(ReservationDatesCell).
                  handing_it(:reservations => [@far_future_reservation])
      view_itself.should_use_widget(ReservationDatesCell).
                  handing_it(:reservations => [@near_future_reservation])
    }
  end
end
