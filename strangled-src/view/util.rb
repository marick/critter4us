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

  def count_annotated(string_array)
    uniqs = string_array.uniq
    # This is simpler in 1.8.7....
    initial_value = Hash[*uniqs.zip([0]*uniqs.size).flatten]
    tagged = string_array.inject(initial_value) do | accumulator, s |
      accumulator[s] += 1
      accumulator
    end
    tagged.collect { | string, count | 
      if count == 1 
        string
      else
        string + " (#{count} times)"
      end
    }.sort
  end

  def without_parens(string_array)
    string_array.collect do | s |
      s.gsub(/\(.*\)/, '').strip
    end
  end

  def highlighted_first_words(string_array)
    string_array.collect do | s |
      s.gsub(/^(\w*)/, '<b>\1</b>').strip
    end
  end

  def detextilized(text)
    rawtext RedCloth.new(text).to_html
  end
  
  
end

module ReservationHelper
  def time_of_day(reservation)
    result = []
    result << MORNING if reservation.uses_morning?
    result << AFTERNOON if reservation.uses_afternoon?
    result << EVENING if reservation.uses_evening?
    result.join(', ')
  end

  def long_form(reservation)
    text "Reservation for the #{time_of_day(reservation)} of #{reservation.date_text},"
    text " made by "
    a "#{reservation.instructor}@illinois.edu",
    :href=>"mailto:#{reservation.instructor}@illinois.edu"
    text " for #{reservation.course}."
  end

end



