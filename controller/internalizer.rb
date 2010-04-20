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
      :timeslice => lambda { | hash | 
        better = convert(hash)
        Timeslice.new(better[:first_date], better[:last_date], better[:times])
      },
      :groups => lambda { | val | val.collect { | group | symbol_keys(group) } },
      :times => lambda { | val | TimeSet.new(val) },
      :reservation_data => lambda { | val | convert_reservation_data(val) }
    }
    @renamings = { :firstDate => :first_date, :lastDate => :last_date }
  end

  def convert(hash)
    result = symbol_keys(hash)
    @converters.each do | key, action | 
      result[key] = action.call(result[key]) if result.has_key?(key)
    end
    @renamings.each do | old_key, new_key | 
      result[new_key] = result.delete(old_key) if result.has_key?(old_key)
    end
    result
  end

  def find_reservation(params, tag)
    reservation_id = integer_or_nil(params[tag])
    if reservation_id
      Reservation[reservation_id]
    else
      Reservation.acts_as_empty
    end
  end

  def convert_reservation_data(json)
    convert(JSON[json])
  end

  def convert_animal_descriptions(json)
    JSON[json]
  end

  def make_timeslice(json)
    internal = convert(JSON.parse(json))
    Timeslice.new(internal[:first_date], internal[:last_date], internal[:times])
  end

  def make_timeslice_from_date(raw_date)
    date = @date_parser.call(raw_date)
    Timeslice.new(date, date, TimeSet.new(MORNING, AFTERNOON, EVENING))
  end

  def integer_or_nil(value)
    value = nil if value == ""
    return nil if value.nil?
    value.to_i
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
