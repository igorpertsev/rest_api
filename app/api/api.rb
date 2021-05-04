class API < Grape::API
  prefix 'api'
  format :json
  mount V1::Contracts
  mount V1::Authenticate
  mount V1::Imports
end