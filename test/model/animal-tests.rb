$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class AnimalTests < FreshDatabaseTestCase

  context "animals" do 
    should "individually be able to return a wire-format of self" do
      assert { Animal.random(:name => 'fred').in_wire_format == 'fred' }
    end

    should "collectively be able to return their names" do
      Animal.random_with_names('c', 'a', 'b')
      assert { Animal.names.sort == ['a', 'b', 'c'] }
    end

    should "be able to return a name=>kind mapping" do
      Animal.random(:name => 'bossie', :kind => 'cow')
      Animal.random(:name => 'fred', :kind => 'horse')
      assert { Animal.kind_map == {'bossie' => 'cow', 'fred' => 'horse'} }
    end

    # TODO: Right now, the user sees all animals in the animal list, including ones
    # who cannot be used by any of the procedures (because they're already being 
    # used at the exact same time). This test would be the start toward fixing that.
    should_eventually "be able to return animals available on a certain date/time" do
      reservation = Reservation.random(:instructor => 'marge',
                                       :course => 'vm333',
                                       :date => Date.new(2001, 01, 02),
                                       :morning => true) do 
        use Animal.random(:name => 'bossie')
        use Procedure.random(:name => 'procedure')
      end
      fred = Animal.random(:name => 'fred', :kind => 'horse')

      assert { [fred] == Animal.available_on(:date => Date.new(2001, 01, 02),
                                             :morning => true) }
    end

  end
end

