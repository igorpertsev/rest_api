class V1::CustomerEntity < Grape::Entity
  expose :name
  expose :email
  expose :address
end