require 'set'

class TimeSet < Set

  def initialize(*args)
    super(args.flatten.compact)
  end
end
