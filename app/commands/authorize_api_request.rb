class AuthorizeAPIRequest
  prepend SimpleCommand
  
  def initialize(headers = {})
    @headers = headers
  end
  
  def call
    decoded_auth_token ? Customer.find(decoded_auth_token[:customer_id]) : nil
  end
  
  private
  
  attr_reader :headers
  
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end
  
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, "Missing token")
    end
    nil
  end
end