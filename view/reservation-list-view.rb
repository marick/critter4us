require './view/util'

class ReservationListView < Erector::Widget     
  include ViewHelper
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
              td(:style => 'width: 7em;') { text r.date_text }
              td { text time_of_day(r) }
              td { a "#{r.instructor}@illinois.edu",
                :href=>"mailto:#{r.instructor}@illinois.edu" }
              td { text r.course }
              td { text r.animal_names.join(', ') }
              td { text r.procedure_names.join(', ') }
              td { rawtext delete_button("/reservation/#{r.id}/#{@days_to_display_after_deletion}") }
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
                  :href => "/reservation/#{r.id}",
                  :target => "_blank")
              end
            end
            tr do
              td(:colspan => 6) do
                detextilized r.note
              end
              td(:colspan => 4) do
                a('Edit Note',
                  :href => note_view_uri(r),
                  :target => "_blank")
              end
            end
          end
        end
      end
    end
  end

  def sorted_reservations
    @reservations.sort { |a, b|
      if a.first_date != b.first_date
        -(a.first_date <=> b.first_date) 
      else
        -(a.times <=> b.times)
      end
    }
  end
end

