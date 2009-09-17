require 'config'
require 'pp'

class Reservation < Sequel::Model
  class ReservationStructureBuilder

    attr_reader :reservation

    def self.build_from(data)
      new(data).reservation
    end

    def initialize(data)
      reservation_part, data_for_each_group =
        partition_reservation_data(data)
      @reservation = Reservation.create(reservation_part)
      data_for_each_group.each do | group_data | 
        grouping = Grouping.create(:reservation => reservation)
        cross_product_of_procedures_and_animals(grouping, group_data)
      end
    end

    private

    def cross_product_of_procedures_and_animals(grouping, group_data)
      group_data[:procedures].each do | procedure_name | 
        group_data[:animals].each do | animal_name |
          build_use(grouping, procedure_name, animal_name)
        end
      end
    end

    def partition_reservation_data(data)
      data = data.dup
      data_for_each_group = data.delete(:groups)
      [data, data_for_each_group]
    end

    def build_use(grouping, procedure_name, animal_name)
      procedure = Procedure[:name => procedure_name]
      animal = Animal[:name => animal_name]
      Use.create(:procedure => procedure,
                 :animal => animal,
                 :grouping => grouping)
    end
  end

  one_to_many :groupings

  def before_destroy
    groupings.each { | grouping | grouping.destroy }
  end

  def self.create_with_groups(data)
    ReservationStructureBuilder.build_from(data)
  end

  def uses
    groupings.collect{ | grouping | grouping.uses }.flatten
  end

  def animal_names; x_names(:animal); end
  def procedure_names; x_names(:procedure); end


  # Self-description and test

  def self.random(overrides = {}, &block)
    defaults = {
      :date => Date.new(2009, 7, 23),
      :course => 'vm333',
      :instructor => 'morin',
      :morning => true
    }
    reservation = create(defaults.merge(overrides))

    if block
      class_eval(&block)

      grouping = Grouping.create(:reservation => reservation)
      Use.create(:grouping => grouping, 
                 :animal => @animal_created_in_block,
                 :procedure => @procedure_created_in_block)
    end
    reservation
  end

  def self.use(thing)
    if thing.is_a?(Animal)
      @animal_created_in_block = thing
    else
      @procedure_created_in_block = thing
    end
  end

  private

  def x_names(x)
    names = uses.collect { | use | 
      use.send(x).name
    }.uniq.sort
  end
end
