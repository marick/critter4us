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

  def date_text
    if (first_date != last_date)
      "#{first_date.to_s} to #{last_date.to_s}"
    else
      first_date.to_s
    end
  end
end
