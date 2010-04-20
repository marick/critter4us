$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'

class ProcedureTests < FreshDatabaseTestCase
  should "collectively be able to return their names" do
    Procedure.random_with_names('c', 'a', 'b')
    assert { Procedure.names.sort == ['a', 'b', 'c'] }
  end

  should "collectively be able to return names, sorted" do
    Procedure.random_with_names('c', 'a', 'b')
    assert { Procedure.sorted_names == ['a', 'b', 'c'] }
  end

  should "be able to return instances of rules" do
    proc = Procedure.random(:name => 'floating')
    DB[:exclusion_rules].insert(:procedure_id => proc.id,
                                :rule => 'HorsesOnly')
    assert { proc.exclusion_rules.length == 1 } 
    assert { proc.exclusion_rules.first.is_a? Rule::HorsesOnly } 
  end

  should "be able to note when a new animal conflicts with any procedures" do
    bessie = Animal.random(:name => 'bessie', :procedure_description_kind => 'bovine')
    jake = Animal.random(:name => 'jake', :procedure_description_kind => 'equine')
    floating = Procedure.random(:name => 'floating')
    DB[:exclusion_rules].insert(:procedure_id => floating.id,
                                :rule => 'HorsesOnly')
    
    Procedure.note_excluded_animals([bessie, jake])

    assert { DB[:excluded_because_of_animal].count == 1 }
    only = DB[:excluded_because_of_animal].first
    assert_equal(bessie.pk, only[:animal_id])
    assert_equal(floating.pk, only[:procedure_id])
  end
end

