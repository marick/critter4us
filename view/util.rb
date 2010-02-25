require 'erector'

module ViewHelper
  include Erector::Mixin

  TableStyle = { :style => "width: 900px", :border=>"1px",
                 :cellpadding => "5px", :cellspacing=>"0px" }

  NarrowTableStyle = { :style => "width: 500px", :border=>"1px",
                 :cellpadding => "5px", :cellspacing=>"0px" }

  def delete_button(route, hash={})
    hash = {:button_text => 'Delete'}.merge(hash)
    erector do 
      form(:method => "POST",
           :action => route) do 
        input(:type => 'submit', :value=>hash[:button_text])
        input(:type => 'hidden', :value=>"DELETE", :name=>"_method")
      end
    end
  end


end

module ReservationHelper
  def time_of_day(reservation)
    reservation.faked_time_TODO_replace_me
  end

  def long_form(reservation)
    text "Reservation for the #{time_of_day(reservation)} of #{reservation.faked_date_TODO_replace_me},"
    text " made by "
    a "#{reservation.instructor}@illinois.edu",
    :href=>"mailto:#{reservation.instructor}@illinois.edu"
    text " for #{reservation.course}."
  end

end



