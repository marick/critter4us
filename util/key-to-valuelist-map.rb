class KeyToValuelistMap < Hash
  def initialize(keys)
    super()
    @reshaper = Reshaper.new
    keys.each do | key | 
      self[key] = []
    end
  end

  def add_specific_pairs(tuple_array, which_key, which_value)
    tuple_array.each do | tuple | 
      self[tuple[which_key]] << tuple[which_value]
    end
    @reshaper.alphasort_valuelist(self)
  end

  def spread_values_among_keys(values)
    keys.each do | key | 
      self[key] += values
    end
    @reshaper.alphasort_valuelist(self)
  end
end
