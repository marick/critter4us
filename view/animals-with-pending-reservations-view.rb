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
        table(NarrowTableStyle) do 
          animals = @animal_source.eager(:uses => {:group => :reservation}).order_by(:name.desc).all
          animals.each do | a |
            reservations = a.reservations_pending_as_of(@date)
            unless reservations.empty?
              tr do 
                td { text a.name }
                td { widget ReservationDatesCell, :reservations => reservations }
              end
            end
          end
        end
      end
    end
  end
end
