require 'pp'
require './util/constants'
require 'ostruct'
require 'set'
require './model/reservation-maker'
require './model/reservation-updater'

class Reservation < Sequel::Model

  one_to_many :groups

  def before_destroy
    groups.each { | group | group.destroy }
    TuplePublisher.new.remove_reservation_exclusions(self.id)
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

  def self.since(date)
    filter("last_date >= ?", date).all
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

  def uses_morning?; times.include?(MORNING); end
  def uses_afternoon?; times.include?(AFTERNOON); end
  def uses_evening?; times.include?(EVENING); end

  def timeslice
    Timeslice.new(first_date, last_date, times)
  end

  def date_text
    timeslice.date_text
  end

  # Self-description and test
  def self.random(overrides = {}, &block)
    defaults = {
      :timeslice => Timeslice.new(Date.new(2009, 7, 23),
                                  Date.new(2009, 7, 23),
                                  TimeSet.new),
      :course => 'vm333',
      :instructor => 'morin',
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

  # TODO: This should be in externalizer.
  def to_hash
    {:instructor => instructor,
      :course => course,
      :timeslice => { 
        :firstDate => first_date,
        :lastDate => last_date,
        :times => times.to_a
      },
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
