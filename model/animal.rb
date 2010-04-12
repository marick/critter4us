require 'pp'

class Animal < Sequel::Model
  one_to_many :uses

  # Postgres 8.3.5 doesn't seem to recognize columns names with underscores. 
  # Try Animal.columns vs. DB[:animals].columns
  def procedure_description_kind 
    self.values[:procedure_description_kind]
  end

  def self.names; map(:name); end
  def self.sorted_names; names.sort; end

  def remove_from_service_as_of(date)
    self.date_removed_from_service = date
    save_changes
  end

  def in_service_on?(date)
    return true unless date_removed_from_service
    date_removed_from_service > date
  end

  def dates_used_after_beginning_of(date)
    reservations_pending_as_of(date).collect { | r | r.last_date }
  end

  def reservations_pending_as_of(date)
    uses.find_all { | u | 
      u.reservation.last_date >= date
    }.collect { | u | 
      u.reservation 
    }.uniq.sort { |a, b |
      -(a.last_date <=> b.last_date)
    }
  end

  def <=>(other)
    name.downcase <=> other.name.downcase
  end

  private

  # following are for testing

  def self.random(overrides = {})
    defaults = {
      :name => 'jake',
      :kind => 'gelding',
      :procedure_description_kind => 'equine'
    }
    create(defaults.merge(overrides));
  end

  def self.random_with_names(*names)
    names.each do | name | 
      random(:name => name)
    end
  end
end

