require 'model/animal'
require 'model/procedure'

TWICE_A_WEEK=3
TWO_WEEKS=14
ONCE_A_MONTH=30
EVERY_TWO_MONTHS=60

class Population < Sequel::Migration

  def up
    puts '==== fake adding procedures and animals'
  end

  def down
    puts "==== emptying procedure and animal tables"
  end
end
