require './strangled-src/view/util'
require './src/db/shapes'

class NewReservationListView < Erector::Widget     
  include ViewHelper
  include ReservationHelper

  def content
    html do 
      head do
        title 'All Reservations'
      end
      body do
        table(TableStyle) do 
          @reservations.each do | r | 
            r = r.become(TimesliceShaped)
            tr do
              td(:style => 'width: 7em;') { text r.date_text }
              td { text r.time_of_day }
              td { a "#{r.instructor}@illinois.edu",
                :href=>"mailto:#{r.instructor}@illinois.edu" }
              td { text r.course }
              td { text r.animal_names.join(', ') }
              td { text r.procedure_names.join(', ') }
              td { rawtext delete_button("/reservation/#{r.pk}/#{@days_to_display_after_deletion}") }
              td do
                form do 
                  input(:type => 'button', :value=>'Edit',
                        :onclick => "window.parent.AppForwarder.edit(#{r.pk})")
                end
              end
              td do
                form do 
                  input(:type => 'button', :value=>'Copy',
                        :onclick => "window.parent.AppForwarder.copy(#{r.pk})")
                end
              end
              td do
                a('View',
                  :href => Href.reservation_viewing_page(r.pk),
                  :target => "_blank")
              end
            end
            tr do
              td(:colspan => 6) do
                detextilized r.note
              end
              td(:colspan => 4) do
                a('Edit Note',
                  :href => Href::Reservation.note_editor_generator(r.pk),
                  :target => "_blank")
              end
            end
          end
        end
      end
    end
  end
end

