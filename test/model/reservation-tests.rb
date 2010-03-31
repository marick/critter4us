$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ReservationTests < FreshDatabaseTestCase

  should "have a class-removal method" do 
    reservation = Reservation.random(:instructor => 'marge',
                                     :animal => Animal.random(:name => 'animal'),
                                     :procedure => Procedure.random(:name => 'procedure'))
    Reservation.erase(reservation.id)
    assert_equal(0, Reservation.count)
    assert_equal(0, Group.count)
    assert_equal(0, Use.count)
  end

  should "delete both self and associated uses and groups" do
    reservation = Reservation.random(:instructor => 'marge',
                                     :animal => Animal.random(:name => 'animal'),
                                     :procedure => Procedure.random(:name => 'procedure'))

    assert { Reservation[:instructor => 'marge'] }
    assert { Reservation.all.size == 1 }
    assert { Group.all.size == 1 }
    assert { Use.all.size == 1 }

    reservation.destroy

    deny { Reservation[:instructor => 'marge'] }
    assert { Reservation.all.size == 0 }
    assert { Group.all.size == 0 }
    assert { Use.all.size == 0 }
  end

  should "leave other reservations and uses alone" do
    deleteme = Reservation.random(:instructor => 'deleteme')
    saveme = Reservation.random(:instructor => 'saveme')
    deleteme.destroy
    deny { Reservation[:instructor => 'deleteme'] }
    assert { Reservation[:instructor => 'saveme'] }
  end

  should "produce a sorted, uniquified list of kinds in use that are relevant to procedure descriptions" do
    Procedure.random(:name => 'procedure')
    flicka = Animal.random(:name => 'flicka', :kind => 'mare', :procedure_description_kind => 'equine')
    betsy = Animal.random(:name => 'betsy', :kind => 'cow', :procedure_description_kind => 'bovine')
    jake = Animal.random(:name => 'jake', :kind => 'gelding', :procedure_description_kind => 'equine')

    test_data = {
      :instructor => 'marge',
      :course => 'vm333',
      :first_date => Date.new(2001, 2, 4),
      :first_date => Date.new(2001, 2, 5),
      :times => TimeSet.new(MORNING),
      :groups => [
                  {:procedures => ['procedure'],
                    :animals => ['flicka', 'jake']},
                  {:procedures => ['procedure'],
                    :animals => ['betsy', 'flicka']}
                ]
    }
    reservation = ReservationMaker.build_from(test_data)

    assert { ['bovine', 'equine'] == reservation.procedure_description_kinds }
  end

    
  should "know about own uses" do 
    animal = Animal.random
    procedure = Procedure.random
    reservation = Reservation.random(:animal => animal, :procedure => procedure)

    assert { reservation.uses == reservation.groups[0].uses }
  end

  should "allow reservation to return a timeslice" do
    first_date = Date.new(2002, 2, 4)
    last_date = Date.new(2002, 2, 5)
    created = Reservation.random(:first_date => first_date,
                                 :last_date => last_date,
                                 :times => TimeSet.new(MORNING, AFTERNOON))
    reservation_to_ignore = Reservation.acts_as_empty
    derived_timeslice = created.timeslice
    assert_equal(first_date, derived_timeslice.first_date)
    assert_equal(last_date, derived_timeslice.last_date)
    assert_equal(TimeSet.new(MORNING, AFTERNOON), derived_timeslice.times)
  end

  should "be able to render itself as a hash" do 
    test_data = {
      :instructor => 'marge',
      :course => 'vm333',
      :first_date => Date.new(2001, 2, 4),
      :last_date => Date.new(2001, 2, 5),
      :times => TimeSet.new(MORNING),
      :groups => [
                  {:procedures => ['procedure'],
                    :animals => ['flicka', 'jake']},
                ]
    }
    reservation = ReservationMaker.build_from(test_data)
    hash = reservation.to_hash
    assert_equal(reservation.instructor, hash[:instructor])
    assert_equal(reservation.course, hash[:course])
    assert_equal(reservation.first_date, hash[:firstDate])
    assert_equal(reservation.last_date, hash[:lastDate])
    assert_equal(reservation.times, hash[:times])
    assert_equal(reservation.groups, hash[:groups])
    assert_equal(reservation.id.to_s, hash[:id])
  end

end
