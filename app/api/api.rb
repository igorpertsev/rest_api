require "grape-swagger"

class API < Grape::API
  prefix 'api'
  format :json
  mount V1::Contracts
  mount V1::Authenticate
  mount V1::Imports

  add_swagger_documentation(
    api_version: "v1",
    hide_documentation_path: true,
    mount_path: "/v1/swagger_doc",
    hide_format: true
  )
end