require 'view/util'


class AnimalsWithPendingReservationsView < Erector::Widget
  include ViewHelper
  needs :animal_source, :date
  

  def content
    html do 
      head do
        title 'Animals With Pending Reservations'
      end
      body do
        table(TableStyle) do 
          animals = @animal_source.order_by(:name.desc).all
          animals.each do | a |
            dates = a.dates_used_after_beginning_of(@date)
            unless dates.empty?
              tr do 
                td { text a.name }
                td { widget ReservationDatesCell, :dates => dates }
              end
            end
          end
        end
      end
    end
  end
end
