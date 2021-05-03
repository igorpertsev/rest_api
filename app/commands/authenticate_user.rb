class AuthenticateUser
  prepend SimpleCommand
  
  def initialize(email, password)
    @email = email
    @password = password
  end
  
  def call
    JsonWebToken.encode(customer_id: api_customer.id) if api_customer
  end
  
  private
  
  attr_accessor :email, :password
  
  def api_customer
    @api_customer ||= begin
      user = Customer.where(email: email).first
      user.present? && user.valid_password?(password) ? user : nil
    end
  end
end