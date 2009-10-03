require 'erector'

module ReservationHelper
  def time_of_day(reservation)
    if reservation.morning
      "morning"
    else
      "afternoon"
    end
  end

  def long_form(reservation)
    text "Reservation for the #{time_of_day(reservation)} of #{reservation.date},"
    text " made by "
    a "#{reservation.instructor}@illinois.edu",
    :href=>"mailto:#{reservation.instructor}@illinois.edu"
    text " for #{reservation.course}."
  end

  TableStyle = { :style => "width: 900px", :border=>"1px",
    :cellpadding => "5px", :cellspacing=>"0px" }

end



