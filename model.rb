require 'config'

class Procedure  < Sequel::Model
  one_to_many :uses

  def self.names; map(:name); end
end

class Animal < Sequel::Model
  one_to_many :uses

  def self.names; map(:name); end
end

class Reservation < Sequel::Model
  one_to_many :uses

  def self.create_with_uses(date, procedures, animals, method=:find_or_create)
    reservation = Reservation.create(:date => date)
    procedures.each do | procedure | 
      animals.each do | animal |
        Use.create(:procedure => Procedure.send(method, :name => procedure),
                   :animal => Animal.send(method, :name => animal),
                   :reservation => reservation)
      end
    end
    reservation
  end

  def animal_names; x_names(:animal); end
  def procedure_names; x_names(:procedure); end

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

  def initialize(date)
    date_string = date.to_s

=begin
    rows = DB["
        SELECT procedures.name as procedure_name, 
               animals.name as animal_name 
        FROM procedures, animals, uses, reservations 
        WHERE procedures.id = uses.procedure_id AND 
              animals.id = uses.animal_id AND 
              reservations.id = uses.reservation_id AND
              ? < ADDDATE(reservations.date, procedures.days_delay);
        ", date_string].to_a
=end

    # Use a join? - don't know how to alias both procedure and animal names.
    rows = DB[:procedures, :animals, :uses, :reservations].
      filter(:procedures__id => :uses__procedure_id).
      filter(:animals__id => :uses__animal_id).
      filter(:reservations__id => :uses__reservation_id).
      filter("? < ADDDATE(reservations.date, procedures.days_delay)", date_string).
      select(:procedures__name.as(:procedure_name),
             :animals__name.as(:animal_name),
             :reservations__date).all   # including date for debugging.

    @hash = hash_with_procedure_keys(rows)
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


