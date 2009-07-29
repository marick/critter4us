require 'test/testutil/requires'
require 'test/testutil/config'

require 'persistent-store'
require 'admin/tables'
require 'model'

class PersistentStoreTests < Test::Unit::TestCase
  def setup
    empty_tables
    @store = PersistentStore.new
  end


  should "return procedure names" do
    Procedure.create(:name => 'c')
    Procedure.create(:name => 'a')
    Procedure.create(:name => 'b')
    
    assert { @store.procedure_names.sort == ['a', 'b', 'c'] }
  end

  should "return animal names" do
    Animal.create(:name => 'c')
    Animal.create(:name => 'a')
    Animal.create(:name => 'b')

    assert { @store.all_animals.sort == ['a', 'b', 'c'] }
  end

  context "exclusions" do
    should "have empty exclusion list if no uses" do 
      Procedure.create(:name => 'only', :days_delay => 14)
      Animal.create(:name => "bossie");

      expected = { 'only' => [] }
      assert { @store.exclusions_for_date(Date.new(2009, 7, 23)) == expected }
    end


    should "have empty exclusion list if at last day of boundary" do 
      procedure = Procedure.create(:name => 'only', :days_delay => 1)
      animal = Animal.create(:name => "bossie");
      Use.create(:animal => animal, :procedure => procedure,
                 :date => Date.new(2002, 12, 1))

      expected = { 'only' => [] }
      assert { @store.exclusions_for_date(Date.new(2002, 12, 2)) == expected }
    end

    should "have excluded animal if within delay" do 
      procedure = Procedure.create(:name => 'only', :days_delay => 2)
      animal = Animal.create(:name => "bossie");
      Use.create(:animal => animal, :procedure => procedure,
                 :date => Date.new(2002, 12, 1))

      expected = { 'only' => ['bossie'] }
      assert { @store.exclusions_for_date(Date.new(2002, 12, 2)) == expected }
    end

    should "run a more typical example" do
      venipuncture = Procedure.create(:name => 'venipuncture', :days_delay => 7)
      physical_exam = Procedure.create(:name => 'physical exam', :days_delay => 1)
      
      veinie = Animal.create(:name => 'veinie')
      bossie = Animal.create(:name => 'bossie')
      staggers = Animal.create(:name => 'staggers')

      Use.create(:animal => bossie, :procedure => venipuncture,
                 :date => Date.new(2009, 8, 31)) # Previous Monday
      Use.create(:animal => staggers, :procedure => venipuncture,
                 :date => Date.new(2009, 9, 1))  # Previous Tuesday
      Use.create(:animal => veinie, :procedure => venipuncture,
                 :date => Date.new(2009, 9, 7))  # Today, Monday
      Use.create(:animal => veinie, :procedure => physical_exam,
                 :date => Date.new(2009, 9, 7))  # Again, Monday

      # What can not be scheduled today?
      actual = @store.exclusions_for_date(Date.new(2009, 9, 7))
      assert { actual['venipuncture'].include?('staggers') }
      assert { actual['venipuncture'].include?('veinie') }
      deny { actual['venipuncture'].include?('bossie') }
      assert { actual['physical exam'].include?('veinie') }
      deny { actual['physical exam'].include?('staggers') }
      deny { actual['physical exam'].include?('bossie') }

      # What can not be scheduled tomorrow?
      actual = @store.exclusions_for_date(Date.new(2009, 9, 8))
      deny { actual['venipuncture'].include?('staggers') }
      assert { actual['venipuncture'].include?('veinie') }
      deny { actual['venipuncture'].include?('bossie') }
      deny { actual['physical exam'].include?('veinie') }
      deny { actual['physical exam'].include?('staggers') }
      deny { actual['physical exam'].include?('bossie') }

      # What can not be scheduled next Sunday?
      actual = @store.exclusions_for_date(Date.new(2009, 9, 13))
      deny { actual['venipuncture'].include?('staggers') }
      assert { actual['venipuncture'].include?('veinie') }
      deny { actual['venipuncture'].include?('bossie') }
      deny { actual['physical exam'].include?('veinie') }
      deny { actual['physical exam'].include?('staggers') }
      deny { actual['physical exam'].include?('bossie') }

      # What can not be scheduled next Monday?
      actual = @store.exclusions_for_date(Date.new(2009, 9, 14))
      deny { actual['venipuncture'].include?('staggers') }
      deny { actual['venipuncture'].include?('veinie') }
      deny { actual['venipuncture'].include?('bossie') }
      deny { actual['physical exam'].include?('veinie') }
      deny { actual['physical exam'].include?('staggers') }
      deny { actual['physical exam'].include?('bossie') }
    end

  end
end
