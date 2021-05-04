class AuthenticateUser
  prepend SimpleCommand
  
  def initialize(email, password)
    @email = email
    @password = password
  end
  
  def call
    JsonWebToken.encode(customer_id: api_customer.id.to_s) if api_customer
  end
  
  private
  
  attr_accessor :email, :password
  
  def api_customer
    @api_customer ||= begin
      user = Customer.where(email: email).first
      if user.present? && user.valid_password?(password) 
        user
      else 
        errors.add :message, "Invalid email / password"
        nil
      end
    end
  end
end