require 'stunted'
require './src/db/database_structure'
require './strangled-src/util/test-support'

class DBHash < Stunted::FunctionalHash
  self.extend(Stunted::FHUtil)
  include Stunted
  include FHUtil
  include TestSupport
  include DatabaseStructure
end

