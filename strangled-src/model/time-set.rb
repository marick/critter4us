require 'set'

class TimeSet < Set

  def self.from_bits(bits)
    vals = bits.split("")
    inits = []
    inits << MORNING if vals[0] == '1'
    inits << AFTERNOON if vals[1] == '1'
    inits << EVENING if vals[2] == '1'
    new(inits)
  end

  def initialize(*args)
    super(args.flatten.compact)
  end

  def bits
    (include?(MORNING) ? "1" : "0") + 
    (include?(AFTERNOON) ? "1" : "0") + 
    (include?(EVENING) ? "1" : "0")
  end

  # There must be a more clever way, but I don't see it.
  def <=>(other)
    compare_bitstrings(bits, other.bits)
  end

  private

  def compare_bitstrings(first, second)
    return 0 if (first == second)
    return -1 if (first.to_i == 0)
    return 1 if (second.to_i == 0)

    first, second = find_lit_bit(first, second)
    result = (first[0] <=> second[0])
    return -result unless result == 0
    
    compare_bitstrings(first[1..-1], second[1..-1])
  end

  def find_lit_bit(first, second)
    return first, second if first.empty?
    return first, second if first[0,1] == '1' or second[0,1] == '1'
    find_lit_bit(first[1..-1], second[1..-1])
  end
end
