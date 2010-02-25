require 'pp'
require 'util/constants'
require 'ostruct'
require 'set'

class Reservation < Sequel::Model
  # TODO: this should probably be a first-class object that can mediate between 
  # "reservation land" and "incoming data land". 
  class ReservationStructureChanger

    attr_reader :reservation

    def self.build_from(data)
      instance = new(data)
      instance.create_with_direct_data
      instance.add_groups
      instance.reservation
    end

    def initialize(data)
      @reservation_part, @data_for_each_group = partition_reservation_data(data)
    end

    def create_with_direct_data
      @reservation = Reservation.create(@reservation_part)
    end

    def update_direct_data
      @reservation.update(@reservation_part)
    end

    def use_reservation(reservation)
      @reservation = reservation
    end

    def destroy_groups
      @reservation.groups.each do | g |
        g.destroy
      end
    end

    def add_groups
      @data_for_each_group.each do | group_data | 
        
        group = Group.create(:reservation => reservation)
        cross_product_of_procedures_and_animals(group, group_data)
      end
    end

    private

    def cross_product_of_procedures_and_animals(group, group_data)
      group_data[:procedures].each do | procedure_name | 
        group_data[:animals].each do | animal_name |
          build_use(group, procedure_name, animal_name)
        end
      end
    end

    def partition_reservation_data(data)
      data = data.dup
      data_for_each_group = data.delete(:groups)
      make_unspecified_time_segments_explicit(data)
      [data, data_for_each_group]
    end

    def make_unspecified_time_segments_explicit(data)
      [:morning, :afternoon, :evening].each do | tag | 
        data[tag] ||= false
      end
    end

    def build_use(group, procedure_name, animal_name)
      procedure = Procedure[:name => procedure_name]
      animal = Animal[:name => animal_name]
      Use.create(:procedure => procedure,
                 :animal => animal,
                 :group => group)
    end
  end

  one_to_many :groups

  def before_destroy
    groups.each { | group | group.destroy }
  end

  def self.create_with_groups(data)
    ReservationStructureChanger.build_from(data)
  end

  def self.acts_as_empty
    o = OpenStruct.new(:animals => [])
    # Need an id field, and this is the way to prevent the "Object#id
    # will be deprecated warning."
    def o.id; -1; end
    def o.acts_as_empty?; true; end
    o
  end

  def uses
    groups.collect{ | group | group.uses }.flatten
  end

  def animal_names; x_names(:animal); end
  def animals; x_objects(:animal); end
  def procedure_names; x_names(:procedure); end
  def procedures; x_objects(:procedure); end
  def acts_as_empty?; false; end

  def procedure_description_kinds
    animals.collect { | animal | animal.procedure_description_kind }.uniq.sort
  end

  def timeslice(ignored_reservation)
    times = Set.new 
    times << MORNING if morning
    times << AFTERNOON if afternoon
    times << EVENING if evening
    Timeslice.new(first_date, last_date, times, ignored_reservation)
  end

  # Self-description and test
  def faked_time_TODO_replace_me
    timeslice(Reservation.acts_as_empty).faked_time_TODO_replace_me
  end

  def faked_date_TODO_replace_me
    timeslice(Reservation.acts_as_empty).faked_date_TODO_replace_me
  end

  def self.random(overrides = {}, &block)
    defaults = {
      :first_date => Date.new(2009, 7, 23),
      :last_date => Date.new(2009, 7, 23),
      :course => 'vm333',
      :instructor => 'morin',
      :morning => false,
      :afternoon => false,
      :evening => false,
    }
    # TODO: Migrate all uses of Reservation.random to new, non-block form.
    convert_old_time_descriptions_to_new(overrides)

    return old_random(defaults.merge(overrides), &block) if block

    animal = overrides.delete(:animal)
    procedure = overrides.delete(:procedure)
    reservation = create(defaults.merge(overrides))

    if animal
      group = Group.create(:reservation => reservation)
      Use.create(:group => group, 
                 :animal => animal,
                 :procedure => procedure)
    end
    reservation
    
  end

  def self.convert_old_time_descriptions_to_new(data)
    if data.has_key?(:date)
      data[:first_date] = data[:last_date] = data.delete(:date)
    end
    if data.has_key?(:time)
      single_time = data.delete(:time)
      case single_time
      when MORNING then data[:morning] = true
      when AFTERNOON then data[:afternoon] = true
      when EVENING then data[:evening] = true
      end
    end
  end

  def self.old_random(values, &block)
    reservation = create(values)

    class_eval(&block)

    group = Group.create(:reservation => reservation)
    Use.create(:group => group, 
               :animal => @animal_created_in_block,
               :procedure => @procedure_created_in_block)
    reservation
  end

  def self.use(thing)
    if thing.is_a?(Animal)
      @animal_created_in_block = thing
    else
      @procedure_created_in_block = thing
    end
  end

  def with_updated_groups(data)
    changer = ReservationStructureChanger.new(data)
    changer.use_reservation(self);
    changer.destroy_groups
    changer.update_direct_data
    changer.add_groups
    self
  end

  private

  def x_names(x)
    x_objects(x).collect { | thing | thing.name }.sort.uniq
  end


  def x_objects(x)
    uses.collect { | use | 
      use.send(x)
    }
  end
end
