class Authorizer
  def initialize(session)
    @session = session
  end

  def already_authorized?
    @session['authorized']
  end

  def authorize(request)
    auth_request ||=  Rack::Auth::Basic::Request.new(request.env)
    return false unless auth_request.provided? &&
                        auth_request.basic? &&
                        auth_request.credentials 
    if auth_request.credentials[1] == 'bar'
      @session['authorized'] = true
    end
    @session['authorized']
  end
end

class AuthorizeEverything
  def already_authorized?
    true
  end
end
