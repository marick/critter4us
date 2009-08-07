require 'test/testutil/requires'
require 'test/testutil/config'
require 'test/testutil/dbhelpers'
require 'admin/tables'
require 'model'

class ModelTests < Test::Unit::TestCase
  def setup
    empty_tables
  end

  context "animals" do
    should "collectively be able to return their names" do
      create(Animal, 'c', 'a', 'b')
      assert { Animal.names.sort == ['a', 'b', 'c'] }
    end
  end


  context "procedures" do 
    should "collectively be able to return their names" do 
      create(Procedure, 'c', 'a', 'b')
      assert { Procedure.names.sort == ['a', 'b', 'c'] }
    end
  end

  context "reservations" do
    should "can create a single 'nested' uses" do
      create(Procedure, 'procedure')
      create(Animal, 'animal')
      date = Date.new(2009, 7, 23)
      reservation = Reservation.create_with_uses(date,
                                                 ['procedure'],
                                                 ['animal'])
      assert { reservation.date == date }
      assert { reservation.uses.size == 1 }
      use = reservation.uses[0]
      assert { use.animal.name == 'animal' }
      assert { use.procedure.name == 'procedure' }
      assert { use.reservation == reservation }
    end


    should "can create the cross-product of procedures and animals" do
      p1, p2 = create(Procedure, 'p1', 'p2')
      a1, a2 = create(Animal, 'a1', 'a2')
      date = Date.new(2009, 7, 23)
      reservation = Reservation.create_with_uses(date,
                                                 ['p1', 'p2'],
                                                 ['a1', 'a2'])
      assert { Use.all.size == 4 }
      assert { Use[:procedure_id => p1.id, :animal_id => a1.id] } 
      assert { Use[:procedure_id => p1.id, :animal_id => a2.id] } 
      assert { Use[:procedure_id => p2.id, :animal_id => a1.id] } 
      assert { Use[:procedure_id => p2.id, :animal_id => a2.id] } 
    end
  end

  context "exclusion maps" do
    should "inform that no animals have been used for any procedure" do
      Procedure.create(:name => 'only', :days_delay => 14)
      Animal.create(:name => "bossie");

      map = ExclusionMap.new(Date.new(2009, 7, 23))
      assert { map.to_hash == { 'only' => [] } }
    end

    should "exclude no animals if at last day of boundary" do 
      procedure = Procedure.create(:name => 'only', :days_delay => 1)
      animal = Animal.create(:name => "bossie");
      reservation = Reservation.create(:date => Date.new(2002, 12, 1))
      Use.create(:animal => animal, :procedure => procedure, :reservation => reservation);


      expected = { 'only' => [] }
      
      map = ExclusionMap.new(Date.new(2002, 12, 2))
      assert { map.to_hash == expected }
    end

    should "have excluded animal if within delay" do 
      procedure = Procedure.create(:name => 'only', :days_delay => 2)
      animal = Animal.create(:name => "bossie");
      reservation = Reservation.create(:date => Date.new(2002, 12, 1))
      Use.create(:animal => animal, :procedure => procedure, :reservation => reservation)

      expected = { 'only' => ['bossie'] }
      map = ExclusionMap.new(Date.new(2002, 12, 2))
      assert { map.to_hash == expected }
    end

    should "run a more typical example" do
      venipuncture = Procedure.create(:name => 'venipuncture', :days_delay => 7)
      physical_exam = Procedure.create(:name => 'physical exam', :days_delay => 1)
      
      veinie = Animal.create(:name => 'veinie')
      bossie = Animal.create(:name => 'bossie')
      staggers = Animal.create(:name => 'staggers')

      eight31 = Reservation.create(:date => Date.new(2009, 8, 31)) # Previous Monday
      nine1 = Reservation.create(:date => Date.new(2009, 9, 1))  # Previous Tuesday
      nine7 = Reservation.create(:date => Date.new(2009, 9, 7))  # Today, Monday

      Use.create(:animal => bossie, :procedure => venipuncture,
                 :reservation => eight31);
      Use.create(:animal => staggers, :procedure => venipuncture,
                 :reservation => nine1);
      Use.create(:animal => veinie, :procedure => venipuncture,
                 :reservation => nine7);
      Use.create(:animal => veinie, :procedure => physical_exam,
                 :reservation => nine7);

      # What can not be scheduled today?
      actual = ExclusionMap.new(Date.new(2009, 9, 7)).to_hash
      assert { actual['venipuncture'].include?('staggers') }
      assert { actual['venipuncture'].include?('veinie') }
      deny { actual['venipuncture'].include?('bossie') }
      assert { actual['physical exam'].include?('veinie') }
      deny { actual['physical exam'].include?('staggers') }
      deny { actual['physical exam'].include?('bossie') }

      # What can not be scheduled tomorrow?
      actual = ExclusionMap.new(Date.new(2009, 9, 8)).to_hash
      deny { actual['venipuncture'].include?('staggers') }
      assert { actual['venipuncture'].include?('veinie') }
      deny { actual['venipuncture'].include?('bossie') }
      deny { actual['physical exam'].include?('veinie') }
      deny { actual['physical exam'].include?('staggers') }
      deny { actual['physical exam'].include?('bossie') }

      # What can not be scheduled next Sunday?
      actual = ExclusionMap.new(Date.new(2009, 9, 13)).to_hash
      deny { actual['venipuncture'].include?('staggers') }
      assert { actual['venipuncture'].include?('veinie') }
      deny { actual['venipuncture'].include?('bossie') }
      deny { actual['physical exam'].include?('veinie') }
      deny { actual['physical exam'].include?('staggers') }
      deny { actual['physical exam'].include?('bossie') }

      # What can not be scheduled next Monday?
      actual = ExclusionMap.new(Date.new(2009, 9, 14)).to_hash
      deny { actual['venipuncture'].include?('staggers') }
      deny { actual['venipuncture'].include?('veinie') }
      deny { actual['venipuncture'].include?('bossie') }
      deny { actual['physical exam'].include?('veinie') }
      deny { actual['physical exam'].include?('staggers') }
      deny { actual['physical exam'].include?('bossie') }
    end


  end
end

