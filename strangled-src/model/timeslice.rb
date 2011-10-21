require './strangled-src/util/requires'
require './strangled-src/model/requires'

Timeslice = Struct.new(:first_date, :last_date, :times) do
  include TestSupport

  def self.random(hash)
    default = {
      :first_date => "2009-01-01",
      :last_date => "2009-11-11",
      :times => [MORNING]
    }
    actual = default.merge(hash)
    new(Date.parse(actual[:first_date]),
        Date.parse(actual[:last_date]),
        TimeSet.new(actual[:times]))
  end

  def self.all_day(first, last)
    new(first, last, TimeSet.new(MORNING, AFTERNOON, EVENING))
  end

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
