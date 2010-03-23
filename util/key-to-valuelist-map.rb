class KeyToValuelistMap < Hash
  def initialize(keys)
    super()
    @reshaper = Reshaper.new
    keys.each do | key | 
      self[key] = []
    end
  end

  def add_specific_pairs(tuple_array, which_key, which_value)
    presentably do 
      tuple_array.each do | tuple | 
        self[tuple[which_key]] << tuple[which_value]
      end
    end
  end

  def spread_values_among_keys(values)
    presentably do 
      keys.each do | key | 
        self[key] += values
      end
    end
  end

  def presentably
    prepare_valuelists_for_modification
    yield
    make_presentable
  end

  def prepare_valuelists_for_modification
    self.each do | key, values | 
      self[key] = values.dup
    end
  end

  def make_presentable
    self.each do | key, values | 
      self[key] = @reshaper.presentable(values)
    end
  end
    

end
