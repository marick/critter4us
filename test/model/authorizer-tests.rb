$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/authorizer'
require 'ostruct'

class AuthorizerfTests < FreshDatabaseTestCase

  def setup
    super
    @session = {}
    @authorizer = Authorizer.new(@session)
  end

  def auth_request(password)
    OpenStruct.new(:provided? => true,
                   :basic? => true,
                   :credentials => ['irrelevant', password])
  end


  should "return false the first time queried" do
    deny { @authorizer.already_authorized? }
  end

  should "treat the first entry of a password to an empty table as creation+entry" do

    # Check arrangement
    deny { @authorizer.already_authorized? }
    assert { DB[:authorizations].all == [] }

    # Act
    assert { @authorizer.authorize(auth_request('password')) }

    # assert
    assert { DB[:authorizations][:magic_word => 'password'] }
    assert { @authorizer.already_authorized? }
  end

  should "require a matching password for success" do
    deny { @authorizer.already_authorized? }
    DB[:authorizations].insert(:magic_word => 'foo')

    assert { @authorizer.authorize(auth_request('foo')) }

    assert { @authorizer.already_authorized? }
  end

  should "fail password mismatch" do
    deny { @authorizer.already_authorized? }
    DB[:authorizations].insert(:magic_word => 'foo')

    deny { @authorizer.authorize(auth_request('MISMATCH')) }

    deny { @authorizer.already_authorized? }
  end
end
