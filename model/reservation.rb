require 'pp'
require 'util/constants'
require 'ostruct'
require 'set'
require 'model/reservation-maker'
require 'model/reservation-updater'

class Reservation < Sequel::Model

  one_to_many :groups

  def before_destroy
    groups.each { | group | group.destroy }
  end

  def self.create_with_groups(data)
    ReservationMaker.build_from(data)
  end

  def self.erase(id)
    self.filter(:id => id).destroy
  end

  def self.acts_as_empty
    o = OpenStruct.new(:animals => [])
    # Need an id field, and this is the way to prevent the "Object#id
    # will be deprecated warning."
    def o.id; -1; end
    def o.acts_as_empty?; true; end
    o
  end

  def self.overlapping(timeslice)
    date = timeslice.first_date
    time = timeslice.times.to_a[0]
    reservations = case time
                   when MORNING 
                     Reservation.filter(:first_date => date, :morning => true).all
                   when AFTERNOON
                     Reservation.filter(:first_date => date, :afternoon => true).all
                   when EVENING
                     Reservation.filter(:first_date => date, :evening => true).all
                   else
                     raise "Whats up?"
                   end
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

  def times
    TimeSet.from_bits(time_bits)
  end

  def timeslice
    Timeslice.new(first_date, last_date, times)
  end

  # Self-description and test
  def faked_time_TODO_replace_me
    timeslice.faked_time_TODO_replace_me
  end

  def faked_date_TODO_replace_me
    timeslice.faked_date_TODO_replace_me
  end

  def self.random(overrides = {}, &block)
    defaults = {
      :first_date => Date.new(2009, 7, 23),
      :last_date => Date.new(2009, 7, 23),
      :course => 'vm333',
      :instructor => 'morin',
      :times => TimeSet.new
    }

    animal = overrides.delete(:animal)
    procedure = overrides.delete(:procedure)
    reservation = ReservationMaker.build_from(defaults.merge(overrides))

    if animal
      group = Group.create(:reservation => reservation)
      Use.create(:group => group, 
                 :animal => animal,
                 :procedure => procedure)
    end
    reservation
  end

  def update_with_groups(data)
    ReservationUpdater.update(self, data)
  end

  def to_hash
    {:instructor => instructor,
      :course => course,
      :firstDate => first_date,
      :lastDate => last_date,
      :times => times,
      :groups => groups,
      :id => pk.to_s
    }
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
