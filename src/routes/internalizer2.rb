require './strangled-src/util/constants'
require 'base64'
require 'json'

class Internalizer2
  def initialize(strangled = nil)
    @strangled = strangled
  end

  def days_in_the_past(day_string)
    days = day_string.to_i
    days = 3650 if days == 0
    days
  end

end
