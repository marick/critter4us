require './src/db/database_structure'
require './src/functional/functional_hash'
require './strangled-src/util/test-support'

class DBHash < FunctionalHash
  self.extend(FHUtil)
  include TestSupport
  include DatabaseStructure
end

