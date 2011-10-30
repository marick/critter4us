require './test/testutil/fast-loading-requires'
require './src/db/full_reservation'
require './src/functional/functionally'
require './strangled-src/util/test-support'
require './strangled-src/model/requires'

# These are fairly end-to-endish tests.

class FunctionallyCodingTests < FreshDatabaseTestCase
  should "be able to copy reservations" do
    animal1 = Animal.random(:name => "animal 1 - in use")
    animal2 = Animal.random(:name => "animal 2 - blackout with procedure 2")
    animal3 = Animal.random(:name => "animal 3")
    procedure1 = Procedure.random(:name => "procedure 1")
    procedure2 = Procedure.random(:name => "procedure 2")
    data = {
      :timeslice => Timeslice.new(Date.new(2009, 7, 23),
                                  Date.new(2009, 8, 24),
                                  TimeSet.new(MORNING)),
      :course => 'vm333',
      :instructor => 'morin',
      :groups => [ {:procedures => ['procedure 1'], :animals => [animal1.name, animal2.name] }, 
                   {:procedures => ['procedure 2'], :animals => [animal1.name, animal2.name, animal3.name] } ]
    }
    old_style = ReservationMaker.build_from(data)

    new_timeslice = {
      :first_date => Date.new(2010, 1, 1),
      :last_date => Date.new(2010, 2, 2),
      :time_bits => "100"
    }

    ExcludedBecauseInUse.insert(:first_date => new_timeslice[:first_date],
                                :last_date => new_timeslice[:first_date],
                                :time_bits => "100",
                                :animal_id => animal1.id)
    ExcludedBecauseOfBlackoutPeriod.insert(:first_date => new_timeslice[:last_date],
                                           :last_date => new_timeslice[:last_date]+10,
                                           :time_bits => "111",
                                           :animal_id => animal2.id,
                                           :procedure_id => procedure2.id)

    result = Functionally.copy_to_timeslice(FullReservation.from_id(old_style.id),
                                            FunctionalTimeslice.from_hash(new_timeslice))

    assert { result.size == 3 }
    assert { result.animals_already_in_use == [animal1.name] }
    assert { result.blacked_out_use_pairs == [ {:animal_name => animal2.name,
                                                 :procedure_name => procedure2.name }] }
    # The reservation is the new one. 
    from_disk = FullReservation.from_id(result.reservation_id)
    deny { from_disk.uses.any? { | use | use.animal_name == animal1.name } } 
    deny { from_disk.uses.any? { | use | 
        use.animal_name == animal2.name && use.procedure_name == procedure2.name
      }}

    # But the other two remain
    assert { from_disk.uses.any? { | use | 
        use.animal_name == animal2.name && use.procedure_name == procedure1.name
      }}
    assert { from_disk.uses.any? { | use | 
        use.animal_name == animal3.name && use.procedure_name == procedure2.name
      }}
  end
end
