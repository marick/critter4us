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
              td do
                form do 
                  input(:type => 'button', :value=>'Copy',
                        :onclick => "window.parent.AppForwarder.copy(#{r.id})")
                end
              end
              td do
                a('View',
                  :href => "reservation/#{r.id}",
                  :target => "_blank")
              end
            end
          end
        end
      end
    end
  end

  def sorted_reservations  # TODO: name should say it's most recent first 
    @reservations.sort { |a, b|
      if a.date != b.date
        -(a.date <=> b.date) 
      else
        -(COMPARABLE(a.day_segment) <=> COMPARABLE(b.day_segment))
      end
    }
  end
end

