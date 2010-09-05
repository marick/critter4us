require 'view/util'

class TimesliceUsageText < Erector::Widget
  include ViewHelper
  needs :timeslice

  def content
    rawtext("Animals in use " + summarize_times(ordered_times, suffix) + summarize_range)
  end

  private

  def summarize_times(ordered_times, suffix)
    case ordered_times.count
    when 1 then "on the #{ordered_times[0]}#{suffix} of "
    when 2 then "during the #{ordered_times[0]}#{suffix} or #{ordered_times[1]}#{suffix} of "
    when 3 then "at any time during "
    end
  end

  def summarize_range
    if @timeslice.first_date == @timeslice.last_date
      @timeslice.first.to_s
    else
      "#{@timeslice.first_date} through #{@timeslice.last_date}"
    end
  end

  def suffix
    @timeslice.first_date == @timeslice.last_date ? "" : "s"
  end

  def ordered_times
    retval = []
    retval << "morning" if @timeslice.times.include?(MORNING)
    retval << "afternoon" if @timeslice.times.include?(AFTERNOON)
    retval << "evening" if @timeslice.times.include?(EVENING)
    retval
  end
end
