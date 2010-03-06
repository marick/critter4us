class Reshaper
  def singleton_tuple_to_sorted_array(tuple_array)
    alphasort(tuple_array.collect { | hash | hash.only_value})
  end

  def one_value_sorted_array(tuple_array, key)
    alphasort(tuple_array.collect { | hash | hash[key] })
  end

  def pairs_to_hash(pair_array, which_key, which_value)
    pair_array.inject({}) do | accumulator, hash | 
      accumulator.merge(hash[which_key] => hash[which_value])
    end
  end

  def alphasort(array)
    array.uniq.sort { | a, b | a.downcase <=> b.downcase }
  end

  def alphasort_valuelist(hash)
    hash.each do | key, values | 
      hash[key] = alphasort(values)
    end
  end
    

end
