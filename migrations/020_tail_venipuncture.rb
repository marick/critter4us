require './strangled-src/util/constants'
require './strangled-src/model/requires'
require 'pp'

class TailVenipuncture020 < Sequel::Migration

  def up
    puts "==== allowing tail venipuncture to be more frequent"
    puts "procedure" 
    procedure = Procedure[:name => "tail venipuncture (cows)"]
    puts procedure.inspect
    procedure[:days_delay] = 1
    puts procedure.inspect
    procedure.save
  end

  def down
    puts "==== unfixing tail venipuncture"
    puts "procedure" 
    procedure = Procedure[:name => "tail venipuncture (cows)"]
    puts procedure.inspect
    procedure[:days_delay] = 3
    puts procedure.inspect
    procedure.save
  end
end
