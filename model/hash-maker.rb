class HashMaker
  def keys_and_pairs(keys, pairs)
    retval = empty_map(keys)
    pairs.each { | procedure, animal |
      retval[procedure.name] << animal.name
    }
    retval.each { | k, v | v.sort!; v.uniq! }
    retval
  end

  private

  def empty_map(keys)
    pairs = keys.inject([]) { | so_far, key | so_far + [key, []] }
    Hash[*pairs]
  end
end
