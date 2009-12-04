require 'util/constants'
require 'json'

class Internalizer
  def convert(hash)
    result = symbol_keys(hash)
    convert_date(result) if result.has_key?(:date)
    convert_groups(result) if result.has_key?(:groups)
    convert_json_data(result) if result.has_key?(:data) # Todo: change key to "json_data"
    result
  end

  # tested
  def symbol_keys(hash)
    retval = {}
    hash.each do | k, v | 
      retval[k.to_sym] = v
    end
    return retval
  end

  def convert_date(hash)
    hash[:date] = Date.parse(hash[:date])
  end

  def convert_groups(hash)
    hash[:groups] = hash[:groups].collect do | group | 
      symbol_keys(group)
    end
  end

  def convert_json_data(hash)
    hash[:data] = convert(JSON.parse(hash[:data]))
  end
end
