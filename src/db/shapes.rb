module TimesliceShaped
  def date_text
    if (first_date != last_date)
      "#{first_date.to_s} to #{last_date.to_s}"
    else
      first_date.to_s
    end
  end

  def uses_morning?;  time_bits[0] == "1"; end
  def uses_afternoon?;  time_bits[1] == "1"; end
  def uses_evening?;  time_bits[2] == "1"; end

  def time_of_day
    result = []
    result << MORNING if uses_morning?
    result << AFTERNOON if uses_afternoon?
    result << EVENING if uses_evening?
    result.join(', ')
  end


end
