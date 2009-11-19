class DateSource
  def current_date_as_string
    Time.now.strftime("%Y-%m-%d")
  end
end
