GrapeSwaggerRails.options.url = '/api/v1/swagger_doc'
GrapeSwaggerRails.options.app_name = 'REST API'
GrapeSwaggerRails.options.before_action do |request|
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
  customer = Customer.where(name: 'swagger', email: 'swagger@swagger.com').first
  token = JsonWebToken.encode(customer_id: customer.id)
  GrapeSwaggerRails.options.headers['Authorization']  = "Bearer #{token}"
end