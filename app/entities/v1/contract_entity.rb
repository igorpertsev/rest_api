class V1::ContractEntity < Grape::Entity
  expose :id do |record|
    record.id.to_s
  end
  expose :price
  expose :start_date
  expose :end_date
  expose :expiry_date
  expose :customer, using: ::V1::CustomerEntity
end