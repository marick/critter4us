class ExcluderShape

  private

  def listhash_with_keys(keys, value = [])
    retval = {}
    keys.each do | k | 
      retval[k] = value.dup
    end
    retval
  end

  def object_by_id(objects)
    Hash[*objects.collect { | o | [o.id, o] }.flatten]
  end

  def add(one, other)
    one.merge(other) do | key, left, right |
      (left + right).uniq.sort
    end
  end

end

