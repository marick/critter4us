require 'config'
require 'pp'

class Reservation < Sequel::Model
  class ReservationStructureBuilder

    attr_reader :reservation

    def self.build_from(data)
      new(data).reservation
    end

    def initialize(data)
      reservation_part = partition_reservation_data(data)
      @reservation = Reservation.create(reservation_part)
      cross_product_of_procedures_and_animals
    end

    private

    def cross_product_of_procedures_and_animals
      @procedure_names.each do | procedure_name | 
        @animal_names.each do | animal_name |
          build_use(procedure_name, animal_name)
        end
      end
    end

    def partition_reservation_data(data)
      data = data.dup
      @procedure_names = data.delete(:procedures)
      @animal_names = data.delete(:animals)
      data
    end

    def build_use(procedure_name, animal_name)
      procedure = Procedure[:name => procedure_name]
      animal = Animal[:name => animal_name]
      Use.create(:procedure => procedure,
                 :animal => animal,
                 :reservation => @reservation)
    end
  end

  one_to_many :uses

  def before_destroy
    uses.each { | use | use.destroy }
  end

  def self.create_with_uses(data)
    ReservationStructureBuilder.build_from(data)
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

      Use.create(:reservation => reservation, 
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
