class V1::ContractEntity < Grape::Entity
  expose :id do |record|
    record.id.to_s
  end
  expose :price, documentation: { type: 'Integer', desc: 'Contract price in cents' }
  expose :start_date, documentation: { type: 'DateTime', desc: 'Contract start date' }
  expose :end_date, documentation: { type: 'DateTime', desc: 'Contract end date' }
  expose :expiry_date, documentation: { type: 'DateTime', desc: 'Contract expiry date' }
  expose :customer, using: ::V1::CustomerEntity
end