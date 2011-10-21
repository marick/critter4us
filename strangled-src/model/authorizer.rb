class Authorizer
  def initialize(session)
    @session = session
  end

  def already_authorized?
    @session['authorized']
  end

  def authorize(auth_request)
    return false unless auth_request.provided? &&
                        auth_request.basic? &&
                        auth_request.credentials
    password = auth_request.credentials[1]
    if DB[:authorizations].all.size == 0
      DB[:authorizations].insert(:magic_word => password)
    end
    if DB[:authorizations].first[:magic_word] == password
      authorize!
    end
    already_authorized?
  end

  def authorize!
    @session['authorized'] = true
  end

end

# This class is used so that tests don't have to fiddle around with logging in. 
class AuthorizeEverything
  def already_authorized?; true; end
end

