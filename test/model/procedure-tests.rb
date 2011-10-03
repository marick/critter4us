require './test/testutil/requires'
require './model/requires'

class ProcedureTests < FreshDatabaseTestCase
  should "collectively be able to return their names" do
    Procedure.random_with_names('c', 'a', 'b')
    assert { Procedure.names.sort == ['a', 'b', 'c'] }
  end

  should "collectively be able to return names, sorted" do
    Procedure.random_with_names('c', 'a', 'b')
    assert { Procedure.sorted_names == ['a', 'b', 'c'] }
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

  should "destroy all that depends on this when destroyed" do
    cow = Animal.random(:procedure_description_kind => "bovine")
    horse = Animal.random(:procedure_description_kind => "equine")
    cow_stays = Procedure.random(:name => "permanent")
    cow_goes = Procedure.random(:name => "defunct")
    horse_stays = Procedure.random(:name => "horse procedure")

    ProcedureDescription.create(:procedure => cow_stays, :animal_kind => "irrelevant", :animal_kind => "irrelevant")
    ProcedureDescription.create(:procedure => cow_goes, :animal_kind => "irrelevant", :animal_kind => "irrelevant")
    ProcedureDescription.create(:procedure => horse_stays, :animal_kind => "irrelevant", :animal_kind => "irrelevant")

    DB[:exclusion_rules].insert(:procedure_id => cow_stays.pk, :rule => "BovineOnly")
    DB[:exclusion_rules].insert(:procedure_id => cow_goes.pk, :rule => "BovineOnly")
    DB[:exclusion_rules].insert(:procedure_id => horse_stays.pk, :rule => "HorsesOnly")

    Procedure.note_excluded_animals([cow, horse])

    cow_goes.destroy
    
    assert_equal([], DB[:exclusion_rules].filter(:procedure_id => cow_goes.pk).all )
    assert_equal([], DB[:excluded_because_of_animal].filter(:procedure_id => cow_goes.pk).all)
    assert_equal([], DB[:procedure_descriptions].filter(:procedure_id => cow_goes.pk).all)

    assert(DB[:exclusion_rules].filter(:procedure_id => cow_stays.pk).all.count > 0)
    assert(DB[:excluded_because_of_animal].filter(:procedure_id => cow_stays.pk).all.count > 0)
    assert(DB[:procedure_descriptions].filter(:procedure_id => cow_stays.pk).all.count > 0)

    assert(DB[:exclusion_rules].filter(:procedure_id => cow_stays.pk).all.count > 0)
    assert(DB[:excluded_because_of_animal].filter(:procedure_id => cow_stays.pk).all.count > 0)
    assert(DB[:procedure_descriptions].filter(:procedure_id => cow_stays.pk).all.count > 0)
  end
end

