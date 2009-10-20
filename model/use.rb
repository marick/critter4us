require 'pp'

class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
  many_to_one :group

  def reservation
    group.reservation
  end

  # TODO: This is all very kludgy.

  def self.combos_unavailable_at(date, morning)
    result = pairify(conflicting_because_of_procedure_delay_period(date))
    result += pairify(conflicting_because_animals_in_use(date, morning))
    result.uniq
  end

  def self.pairify(row_array)
    row_array.collect { | row | [row[:procedure_name], row[:animal_name]] }
  end

  def self.conflicting_because_of_procedure_delay_period(desired_date)
    query = DB[:expanded_uses].
      filter {|o| o.days_delay > 0 }.
      filter {|o| o.first_available_date > desired_date }.
      filter {|o| o.first_excluded_date <= desired_date }.
      select(:procedure_name, :animal_name)
    # puts query.sql
    # puts query.all.inspect
    query.all
  end

  # TODO: It would probably be better to deliver a list of animals
  # that are in-use at the desired time. That would make it easier
  # to exclude animals right off the bat and would eliminate the 
  # silly join below.
  def self.conflicting_because_animals_in_use(desired_date, in_morning)
    query = DB[:expanded_uses].
      filter(:reservation_date => desired_date).
      filter(:reservation_morning => in_morning).
      join_table(:cross, :procedures).
      select(:name.as(:procedure_name), :animal_name)
    # puts query.sql
    # puts query.all.inspect
    query.all
  end

end



