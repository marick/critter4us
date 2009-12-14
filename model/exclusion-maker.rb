class ExclusionMaker

  private

  def listhash_with_keys(keys)
    retval = {}
    keys.each do | k | 
      retval[k] = []
    end
    retval
  end

  def object_by_id(objects)
    Hash[*objects.collect { | o | [o.id, o] }.flatten]
  end

end

