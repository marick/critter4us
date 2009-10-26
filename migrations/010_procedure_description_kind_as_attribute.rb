require 'model/requires'

class Performance010 < Sequel::Migration

  def up
    puts "==== Adding procedure_description_kind"
    DB.add_column :animals, :procedure_description_kind, String
    DB[:animals].filter(:name => "All Star").update(:procedure_description_kind => "equine")
    DB[:animals].filter(:name => "Genesis").update(:procedure_description_kind => "equine")
    DB[:animals].filter(:name => "Pumpkin").update(:procedure_description_kind => "equine")
    DB[:animals].filter(:name => "Misty").update(:procedure_description_kind => "equine")
    DB[:animals].filter(:name => "Good Morning Sunshine").update(:procedure_description_kind => "equine")
    DB[:animals].filter(:name => "Boombird").update(:procedure_description_kind => "equine")
    DB[:animals].filter(:name => "Sunny").update(:procedure_description_kind => "equine")
    DB[:animals].filter(:name => "Brooke").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "00078").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "00153").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "00912").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "01441").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "01788").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "16167").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "20429").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "20834").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "21126").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "21251").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "22617").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "23261").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "23267").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "23551").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "23940").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "24435").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "24447").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "24605").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "24638").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "24711").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "24794").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "24881").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "24883").update(:procedure_description_kind => "bovine")
    DB[:animals].filter(:name => "goat  1").update(:procedure_description_kind => "caprine")
    DB[:animals].filter(:name => "goat  2").update(:procedure_description_kind => "caprine")
    DB[:animals].filter(:name => "goat  3").update(:procedure_description_kind => "caprine")
    DB[:animals].filter(:name => "goat  4").update(:procedure_description_kind => "caprine")
    DB[:animals].filter(:name => "goat  5").update(:procedure_description_kind => "caprine")
    DB[:animals].filter(:name => "goat  6").update(:procedure_description_kind => "caprine")
    DB[:animals].filter(:name => "goat  7").update(:procedure_description_kind => "caprine")
    DB[:animals].filter(:name => "goat  8").update(:procedure_description_kind => "caprine")
    DB[:animals].filter(:name => "goat  9").update(:procedure_description_kind => "caprine")
    DB[:animals].filter(:name => "goat 10").update(:procedure_description_kind => "caprine")
    DB[:animals].filter(:name => "goat 11").update(:procedure_description_kind => "caprine")
    puts "==== Exclusion Pairs"
    DB.create_table :exclusion_pairs do
      primary_key
  end

  def down
    puts "==== Dropping table that maps two ways of describing animal kinds"
    DB.drop_column :animals, :procedure_description_kind
  end
end
