$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class ReservationListViewTests < FreshDatabaseTestCase
  include ViewHelper

  should "sort reservations" do
    earlier = Reservation.random(:timeslice => Timeslice.new(Date.new(2008, 8, 8),
                                                             Date.new(2010, 10, 10),
                                                             TimeSet.new))

    afternoon = Reservation.random(:timeslice => Timeslice.new(Date.new(2009, 9, 9),
                                                               Date.new(2009, 9, 19),
                                                               TimeSet.new(AFTERNOON)))

    morning = Reservation.random(:timeslice => Timeslice.new(Date.new(2009, 9, 9),
                                                             Date.new(2009, 9, 12),
                                                             TimeSet.new(MORNING)))

    evening = Reservation.random(:timeslice => Timeslice.new(Date.new(2009, 9, 9),
                                                             Date.new(2009, 9, 9),
                                                             TimeSet.new(EVENING)))

    view = ReservationListView.new(:reservations => [afternoon, earlier, evening, morning])
    assert_equal([evening, afternoon, morning, earlier], view.sorted_reservations)
  end

  should "display contents from each reservation" do
    first = Reservation.random(:course => 'v=m=1')
    second = Reservation.random(:course => 'v=m=2')

    output = ReservationListView.new(:reservations => [first, second]).to_s
    assert { /v=m=1/ =~ output }
    assert { /v=m=2/ =~ output }
  end

  should "display entirety of reservation" do
    reservation = Reservation.random(:timeslice => Timeslice.random(:times => [AFTERNOON]),
                                     :animal => Animal.random,
                                     :procedure => Procedure.random)

    r = lambda { | string | Regexp.new(Regexp.escape(string)) }

    output = ReservationListView.new(:reservations => [reservation]).to_s
    assert { r[reservation.instructor] =~ output }
    assert { r[reservation.course] =~ output }
    assert { r[reservation.date_text] =~ output }
    assert { r['afternoon'] =~ output }
    assert { r[reservation.uses[0].animal.name] =~ output }
    assert { r[reservation.uses[0].procedure.name] =~ output }
  end

  should "contain well-formed delete button" do
    reservation = Reservation.random(:course => 'v=m=1')

    output = ReservationListView.new(:reservations => [reservation],
                                     :days_to_display_after_deletion => 321).to_s
    assert { output.include? delete_button("/reservation/#{reservation.id}/321") } 
  end

  should "contain well-formed edit button" do
    reservation = Reservation.random

    output = ReservationListView.new(:reservations => [reservation]).to_s
    assert_xhtml(output) do
      td do
        input(:type => 'button', :value => "Edit",
              :onclick => "window.parent.AppForwarder.edit(#{reservation.id})")
      end
    end
  end

  should "contain well-formed copy button" do
    reservation = Reservation.random

    output = ReservationListView.new(:reservations => [reservation]).to_s
    assert_xhtml(output) do
      td do
        input(:type => 'button', :value => "Copy",
              :onclick => "window.parent.AppForwarder.copy(#{reservation.id})")
      end
    end
  end

  should "contain a link to the reservation view" do
    reservation = Reservation.random

    output = ReservationListView.new(:reservations => [reservation]).to_s
    assert_xhtml(output) do
      td do
        a(/View/, :href => %r{/reservation/#{reservation.pk}})
      end
    end
  end

end

