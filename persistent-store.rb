require 'config'
require 'pp'

class PersistentStore
  def procedure_names
    DB[:procedures].map(:name)
  end

  def all_animals
    DB[:animals].map(:name)
  end

  # Note assumption that date being chosen cannot precede
  # a date of use. (That is, date chosen is in the future.)
  def exclusions_for_date(date)
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

    
    # Use a join?
    rows = DB[:procedures, :animals, :uses, :reservations].
      filter(:procedures__id => :uses__procedure_id).
      filter(:animals__id => :uses__animal_id).
      filter(:reservations__id => :uses__reservation_id).
      filter("? < ADDDATE(reservations.date, procedures.days_delay)", date_string).
      select(:procedures__name.as(:procedure_name),
             :animals__name.as(:animal_name),
             :reservations__date).all   # including date for debugging.

    hash_with_procedure_keys(rows)
  end

  def empty_procedure_map
    procedures = DB[:procedures].map(:name)
    pairs = procedures.inject([]) { | so_far, name | so_far + [name, []] }
    Hash[*pairs]
  end

  def create_reservation(date, animal_procedure_pairs = [])
    Reservation.create(:date => date)
  end

private

  def hash_with_procedure_keys(rows)
    retval = self.empty_procedure_map
    rows.each do | row |
      retval[row[:procedure_name]] << row[:animal_name]
    end
    retval
  end


end
