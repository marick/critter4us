require 'config'
require 'pp'

class ExclusionMap

  def initialize(desired_date, in_morning)
    already_used_exclusions = conflicting_because_animals_in_use(desired_date, in_morning)
    diff_day_exclusions = conflicting_because_of_procedure_delay_period(desired_date)
    @hash = hash_with_procedure_keys(diff_day_exclusions + already_used_exclusions)
  end

  def conflicting_because_of_procedure_delay_period(desired_date)
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
  def conflicting_because_animals_in_use(desired_date, in_morning)
    query = DB[:expanded_uses].
      filter(:reservation_date => desired_date).
      filter(:reservation_morning => in_morning).
      join_table(:cross, :procedures).
      select(:name.as(:procedure_name), :animal_name)
    # puts query.sql
    # puts query.all.inspect
    query.all
  end

  def allowing(allowed)
    @hash.each do | procedure, excluded |
      @hash[procedure] = excluded - allowed
    end
    self
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
    # The sorting is for testing. The uniq! is no longer necessary,
    # but is a desirable invariant anyway.
    retval.each { | k, v | v.sort!; v.uniq! }
    retval
  end

end

