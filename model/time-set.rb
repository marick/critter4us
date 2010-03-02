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
end
