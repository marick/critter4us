require 'util/requires'
require 'model/requires'

Timeslice = Struct.new(:first_date, :last_date, :times) do
  include TestSupport

  def self.degenerate(date, time)
    new(date, date, TimeSet.new(time))
  end

  def time_bits
    times.bits
  end

  def faked_date_TODO_replace_me
    first_date
  end

  def faked_time_TODO_replace_me
    times.to_a.first
  end
end
