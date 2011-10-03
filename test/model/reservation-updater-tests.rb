require './test/testutil/requires'
require './model/requires'
require './model/reservation-updater'

class ReservationUpdaterTests < FreshDatabaseTestCase

  context "replacing data" do 
    setup do 
      @reservation = Reservation.random(:instructor => 'marge',
                                        :course => 'vm333',
                                        :timeslice => Timeslice.new(Date.new(2001, 1, 1),
                                                                    Date.new(2001, 2, 2),
                                                                    TimeSet.new(MORNING)),
                                        :animal => Animal.random(:name => 'animal'),
                                        :procedure => Procedure.random(:name => 'procedure'))
      @bet = Animal.random(:name => 'betsy')
      @jake = Animal.random(:name => 'jake')
      @floating = Procedure.random(:name => 'floating')
      @venipuncture = Procedure.random(:name => 'venipuncture')

      @old_group_ids = @reservation.groups.collect { | g | g.id }
      @old_use_ids = @reservation.uses.collect { | u | u.id }

      @new_data = {
        :instructor => 'not marge',
        :course => 'not vm333',
        :timeslice => Timeslice.new(Date.new(2012, 11, 11),
                                    Date.new(2012, 12, 12),
                                    TimeSet.new(EVENING)),
        :groups => [ {:procedures => ['venipuncture'],
                       :animals => ['betsy']},
                     {:procedures => ['floating'],
                       :animals => ['jake', 'betsy']}]
      }

      ReservationUpdater.update(@reservation, @new_data)
    end

    should "delete old groups" do
      @old_group_ids.each do | id |
        deny { Group[id] }
      end
      @old_use_ids.each do | id | 
        deny { Use[id] }
      end
    end

    should "add new groups" do
      new_reservation = Reservation[@reservation.pk]

      assert { new_reservation.groups.length == 2 }
      assert { new_reservation.uses.length == 3 }
      assert { Use[:procedure_id => @venipuncture.id, :animal_id => @betsy.id] }
      assert { Use[:procedure_id => @floating.id, :animal_id => @jake.id] }
      assert { Use[:procedure_id => @floating.id, :animal_id => @betsy.id] }
    end

    should "replace unstructured data" do
      new_reservation = Reservation[@reservation.pk]
      assert { new_reservation.instructor == @new_data[:instructor] }
      assert { new_reservation.course == @new_data[:course] }
      assert { new_reservation.first_date == @new_data[:timeslice][:first_date]}
      assert { new_reservation.last_date == @new_data[:timeslice][:last_date]}
      assert { new_reservation.times == TimeSet.new(EVENING) }
    end
  end
end

