require './test/testutil/fast-loading-requires'
require './src/db/full_reservation'
require './src/functional/functionally'
require './strangled-src/model/requires'


# End-to-end tests should be done in controller/routes tests.

class FunctionallyCodingTests < FreshDatabaseTestCase
end
