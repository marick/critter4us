require 'util/constants'
require 'model/requires'
require 'json'

class Externalizer
  def convert(hash)
    convert_hash(hash).to_json
  end

  def convert_hash(hash)
    converted = {}
    hash.each do | key, value | 
      converted[convert_one(key)] = convert_one(value)
    end
    converted
  end

  def convert_one(value)
    case value
    when Array then
      value.map { | one | convert_one(one) }
    when Hash then
      convert_hash(value)
    when Animal, Procedure then
      value.name
    else
      value
    end
  end
end
