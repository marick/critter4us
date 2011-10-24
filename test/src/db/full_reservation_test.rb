require './test/testutil/requires'
require './src/db/full_reservation'

class FullReservationTest < FreshDatabaseTestCase
  include FHUtil

  def setup
    @old_format = Reservation.random(:animal => Animal.random(:name => "animal"),
                                     :procedure => Procedure.random(:name => "procedure"),
                                     :timeslice => Timeslice.new(Date.new(2009, 7, 23),
                                                                 Date.new(2009, 8, 24),
                                                                 TimeSet.new(MORNING)),
                                     :course => 'vm333',
                                     :instructor => 'morin')
    @reservation = FullReservation.from_id(@old_format.id)
  end

  should "be read from database" do
    assert { @reservation.starting_id == @old_format.id }
    assert { @reservation.data.instructor == 'morin' }
    assert { @reservation.data.course == 'vm333' }
    assert { @reservation.data.first_date == Date.new(2009, 7, 23) }
    assert { @reservation.data.last_date == Date.new(2009, 8, 24) }
    assert { @reservation.data.time_bits == "100" }

    only_use = @reservation.uses.first
    assert { only_use.animal_name == 'animal' }
    assert { only_use.procedure_name == 'procedure' }
    assert { only_use.group_id == @reservation.groups.first.id }
  end

  context "changing the time" do 
    setup do
      timeslice = F(:first_date => @reservation.data.first_date + 1,
                    :last_date => @reservation.data.last_date + 2,
                    :time_bits => "111")
      @new_reservation = @reservation.with_changed_timeslice(timeslice)
    end

    should "change the three relevant fields" do 
      assert { @new_reservation.data.first_date == Date.new(2009, 7, 24) }
      assert { @new_reservation.data.last_date == Date.new(2009, 8, 26) }
      assert { @new_reservation.data.time_bits == "111" }
    end

    should "not affect the original reservation"  do
      assert { @reservation.data.first_date == Date.new(2009, 7, 23) }
      assert { @reservation.data.last_date == Date.new(2009, 8, 24) }
      assert { @reservation.data.time_bits == "100" }
    end

    should "not change other fields" do 
      assert { @new_reservation.data.instructor == @reservation.data.instructor }
      assert { @new_reservation.uses == @reservation.uses } 
    end

    should "clear out the id field to prevent accidental overwriting" do
      assert { ! @new_reservation.data.has_key?(:id) }
      # but still has record of original
      assert { @new_reservation.starting_id == @reservation.starting_id }
    end
  end
end
