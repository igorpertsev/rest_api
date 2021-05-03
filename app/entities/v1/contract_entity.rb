class V1::ContractEntity < Grape::Entity
  expose :price
  expose :start_date
  expose :end_date
  expose :expiry_date
  expose :customer, using: ::V1::CustomerEntity
end