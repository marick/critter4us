require 'config'
require 'pp'

class Procedure  < Sequel::Model
  one_to_many :uses

  def self.names; map(:name); end

  # self description / testing

  def self.random(overrides = {})
    defaults = {
      :name => 'procedure',
      :days_delay => 3
    }
    create(defaults.merge(overrides));
  end

  def self.random_with_names(*names)
    names.each do | name | 
      random(:name => name)
    end
  end

end

class Animal < Sequel::Model
  one_to_many :uses

  # self description / testing

  def self.random(overrides = {})
    defaults = {
      :name => 'bossy',
      :kind => 'bovine'
    }
    create(defaults.merge(overrides));
  end

  def self.random_with_names(*names)
    names.each do | name | 
      random(:name => name)
    end
  end
end

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

class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
  many_to_one :reservation
end

class ExclusionMap

  def initialize(desired_date, in_morning)
    same_day_exclusions = exclude_for_procedures_with_no_delay(desired_date, in_morning)
    diff_day_exclusions = exclude_for_procedures_with_delay(desired_date)
    @hash = hash_with_procedure_keys(same_day_exclusions + diff_day_exclusions)
  end


  def exclude_for_procedures_with_no_delay(desired_date, in_morning)
    query = DB[:expanded_uses].
      filter(:days_delay => 0).
      filter(:reservation_morning => in_morning).
      select(:procedure_name, :animal_name, :reservation_morning)
    #puts query.sql
    #puts query.all.inspect
    query.all
  end

  def exclude_for_procedures_with_delay(desired_date)
    query = DB[:expanded_uses].
      filter {|o| o.days_delay > 0 }.
      filter {|o| o.first_available_date > desired_date }.
      filter {|o| o.first_excluded_date <= desired_date }.
      select(:procedure_name, :animal_name)
    # puts query.sql
    # puts query.all.inspect
    query.all
  end

  def to_hash
    @hash
  end

private

  def empty_procedure_map
    procedures = DB[:procedures].map(:name)
    pairs = procedures.inject([]) { | so_far, name | so_far + [name, []] }
    Hash[*pairs]
  end

  def hash_with_procedure_keys(rows)
    retval = empty_procedure_map
    rows.each do | row |
      retval[row[:procedure_name]] << row[:animal_name]
    end
    retval
  end

end


