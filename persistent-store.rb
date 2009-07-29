require 'config'

class PersistentStore
  def procedure_names
    DB[:procedures].map(:name)
  end

  def all_animals
    DB[:animals].map(:name)
  end

  # Todo: use the silly database the way it was intended.
  def exclusions_for_date(date)
    date_string = date.to_s

    rows = DB["
        SELECT procedures.name as procedure_name, 
               animals.name as animal_name 
        FROM procedures, animals, uses 
        WHERE procedures.id = uses.procedure_id AND 
              animals.id = uses.animal_id AND 
              uses.date <= ? AND 
              ? <= ADDDATE(uses.date, procedures.days_delay);
        ", date_string, date_string].to_a

    rows_to_hash(rows)
  end

  def rows_to_hash(rows)
    retval = self.empty_procedure_map
    rows.each do | row |
      retval[row[:procedure_name]] << row[:animal_name]
    end
    retval
  end

  def empty_procedure_map
    procedures = DB[:procedures].map(:name)
    pairs = procedures.inject([]) { | so_far, name | so_far + [name, []] }
    Hash[*pairs]
  end
                  

end
