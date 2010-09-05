require 'util/requires'
require 'model/requires'

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


  def pretty
    summarize_times(ordered_times, suffix) + summarize_range
  end

  private

  def summarize_times(ordered_times, suffix)
    case ordered_times.count
    when 1 then "on the #{ordered_times[0]}#{suffix} of "
    when 2 then "on the #{ordered_times[0]}#{suffix} and #{ordered_times[1]}#{suffix} of "
    when 3 then "for the whole day on "
    end
  end

  def summarize_range
    if first_date == last_date
      first.to_s
    else
      "#{first_date} through #{last_date}"
    end
  end

  def suffix
    first_date == last_date ? "" : "s"
  end

  def ordered_times
    retval = []
    retval << "morning" if times.include?(MORNING)
    retval << "afternoon" if times.include?(AFTERNOON)
    retval << "evening" if times.include?(EVENING)
    retval
  end

end
