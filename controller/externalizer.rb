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
    when Group then
      convert_group(value)
    when Set then
      value.to_a.sort
    else
      value
    end
  end

  def convert_group(group)
    { 
      'procedures' => collect_each_for_group(:procedure, group),
      'animals' => collect_each_for_group(:animal, group),
    }
  end

  def collect_each_for_group(attribute, group)
    group.uses.collect { |use| convert_one(use.send(attribute)) }.uniq.sort
  end
      

end
