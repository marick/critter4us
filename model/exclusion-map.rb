require 'config'
require 'pp'

class ExclusionMap

  def initialize(desired_date, in_morning)
    same_day_exclusions = exclude_for_procedures_with_no_delay(desired_date, in_morning)
    diff_day_exclusions = exclude_for_procedures_with_delay(desired_date)
    @hash = hash_with_procedure_keys(same_day_exclusions + diff_day_exclusions)
  end


  def exclude_for_procedures_with_no_delay(desired_date, in_morning)
    query = DB[:expanded_uses].
      filter(:reservation_date => desired_date).
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

