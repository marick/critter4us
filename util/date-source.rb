class DateSource
  def current_date_as_string
    Time.now.strftime("%Y-%m-%d")
  end

  def current_date
    Date.parse(current_date_as_string)
  end
end
