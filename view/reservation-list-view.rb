require 'view/util'

class ReservationListView < Erector::Widget
  include ReservationHelper

  def content
    html do 
      head do
        title 'All Reservations'
      end
      body do
        table(TableStyle) do 
          sorted_reservations.each do | r | 
            tr do
              td(:style => 'width: 7em;') { text r.date.to_s }
              td { text time_of_day(r) }
              td { a "#{r.instructor}@illinois.edu",
                :href=>"mailto:#{r.instructor}@illinois.edu" }
              td { text r.course }
              td { text r.animal_names.join(', ') }
              td { text r.procedure_names.join(', ') }
              td do
                form(:method => "POST",
                     :action => "reservation/#{r.id}") do 
                  input(:type => 'submit', :value=>'Delete')
                  input(:type => 'hidden', :value=>"DELETE", :name=>"_method")
                end
              end
              td do
                form do 
                  input(:type => 'button', :value=>'Edit',
                        :onclick => "window.parent.AppForwarder.edit(#{r.id})")
                end
              end
            end
          end
        end
      end
    end
  end

  def sorted_reservations
    @reservations.sort { |a, b|
      if a.date != b.date
        a.date <=> b.date
      elsif a.morning == b.morning
        0
      elsif a.morning
        -1
      else
        1
      end
    }
  end
end

