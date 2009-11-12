require 'erector'

module ViewHelper
  include Erector::Mixin

  TableStyle = { :style => "width: 900px", :border=>"1px",
                 :cellpadding => "5px", :cellspacing=>"0px" }

  def delete_button(route)
    erector do 
      form(:method => "POST",
           :action => route) do 
        input(:type => 'submit', :value=>'Delete')
        input(:type => 'hidden', :value=>"DELETE", :name=>"_method")
      end
    end
  end


end

module ReservationHelper
  def time_of_day(reservation)
    reservation.time
  end

  def long_form(reservation)
    text "Reservation for the #{time_of_day(reservation)} of #{reservation.date},"
    text " made by "
    a "#{reservation.instructor}@illinois.edu",
    :href=>"mailto:#{reservation.instructor}@illinois.edu"
    text " for #{reservation.course}."
  end

end



