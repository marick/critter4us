require './test/testutil/fast-loading-requires'
require './src/db/database_structure'

class ReservationTableTests < FreshDatabaseTestCase
  context "all_with_unique_names" do 

    setup do 
      DB[:animals].insert(:id => 10, :name => "jake")
      DB[:animals].insert(:id => 20, :name => "betsy")
      DB[:animals].insert(:id => 30, :name => "unused")

      DB[:procedures].insert(:id => 10, :name => "trim")
      DB[:procedures].insert(:id => 20, :name => "amnio")
      DB[:procedures].insert(:id => 30, :name => "unused")

      ReservationTable.insert(:id => 10,
                              :last_date => Date.today,
                              :time_bits => "100")   # For some reason, there's a non-NULL db validation.

      GroupTable.insert(:id => 10, :reservation_id => 10)

      UsesTable.insert(:id => 10, :animal_id => 10, :procedure_id => 10, :group_id => 10)
      UsesTable.insert(:id => 20, :animal_id => 10, :procedure_id => 20, :group_id => 10)
      UsesTable.insert(:id => 30, :animal_id => 20, :procedure_id => 10, :group_id => 10)
      UsesTable.insert(:id => 40, :animal_id => 20, :procedure_id => 20, :group_id => 10)
    end

    should "allow fetching down to names" do
      rows = ReservationTable.all_with_unique_names
      assert { rows.count == 1 }
      only = rows.first
      assert { only.pk == 10 }
      assert { only.time_bits == "100" } 
      # Note that names are sorted and uniqified. 
      assert { only.procedure_names == ["amnio", "trim"] } 
      assert { only.animal_names == ["betsy", "jake"] } 
    end

    should "allow appending conditions to the dataset before the SQL is executed" do 
      rows = ReservationTable.all_with_unique_names { | dataset |
        dataset.filter{ last_date < Date.new(1980, 1, 1)  }
      }
      assert { rows.empty? }
    end
  end

  should "return rows back to a particular (inclusive) date" do 
    ReservationTable.insert(:id => 10, :last_date => Date.today - 0, :time_bits => "100")
    ReservationTable.insert(:id => 20, :last_date => Date.today - 1, :time_bits => "100")
    ReservationTable.insert(:id => 30, :last_date => Date.today - 2, :time_bits => "100")

    rows = ReservationTable.rows_back_to(Date.today - 1)
    assert { rows.map(&:pk).sort == [10, 20] }
  end
end
