require 'view/util'

class ReservationDatesCell < Erector::Widget
  include ViewHelper
  needs :dates

  def content
    text(@dates.join(', '))
  end

end
