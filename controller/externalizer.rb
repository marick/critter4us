require 'util/constants'
require 'json'

class Externalizer
  def convert(hash)
    hash.to_json
  end
end
