require 'base64'

module DataUtils
  def encode_url_param(object)
    Base64.encode64(object.to_json)
  end
end
