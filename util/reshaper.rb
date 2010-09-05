require 'ostruct'

class Reshaper
  def tuples_to_presentable_array(tuple_array, key = tuple_array[0].only_key)
    presentable(tuple_array.collect { | hash | hash[key] })
  end

  def pairs_to_hash(pair_array, which_key, which_value)
    pair_array.inject({}) do | accumulator, hash | 
      accumulator.merge(hash[which_key] => hash[which_value])
    end
  end

  def group_by(pair_array, which_key, which_value)
    pair_array.inject({}) do | accumulator, hash | 
      accumulator[hash[which_key]] = [] unless accumulator[hash[which_key]]
      accumulator[hash[which_key]] << hash[which_value] if hash[which_value]
      accumulator
    end
  end

  def empty_key_groups(pair_array, which_key)
    group_by(pair_array, which_key, 'some value name that could not possibly exist')
  end

  def presentable(array)
    result = array.uniq.sort { | a, b | a.downcase <=> b.downcase }
    def result.legacy
      @_legacy = OpenStruct.new unless @_legacy
      @_legacy
    end
    result.legacy.presentable = true
    result.freeze
    result
  end
end
