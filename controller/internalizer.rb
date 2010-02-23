require 'util/constants'
require 'json'

class Internalizer
  def initialize 
    @date_parser = lambda { | val | Date.parse(val) }
    @convert_unjsonified_val = lambda { | val | convert(JSON.parse(val)) }
    @converters = {
      :date => @date_parser, :firstDate => @date_parser, :lastDate => @date_parser,
      # Todo: change next key to "json_data"
      :data => @convert_unjsonified_val,
      :timeslice => @convert_unjsonified_val,
      :groups => lambda { | val | val.collect { | group | symbol_keys(group) } },
      :times => lambda { | val | Set.new(val) },
    }
  end

  def convert(hash)
    result = symbol_keys(hash)
    @converters.each do | key, action | 
      result[key] = action.call(result[key]) if result.has_key?(key)
    end
    result
  end

  def find_reservation(params, tag)
    reservation_id = params[tag]
    if reservation_id
      Reservation[reservation_id.to_i]
    else
      Reservation.acts_as_empty
    end
  end

  def make_timeslice(params, one_reservation = Reservation.acts_as_empty)
    internal = convert(params)
    first_date = internal[:firstDate] || internal[:date]
    last_date = internal[:lastDate] || internal[:date]
    times = internal[:times] || [MORNING]
    Timeslice.new(first_date, last_date, times,
                  one_reservation)
  end

  # tested
  def symbol_keys(hash)
    retval = {}
    hash.each do | k, v | 
      retval[k.to_sym] = v
    end
    return retval
  end
end
