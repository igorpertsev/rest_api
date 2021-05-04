class V1::ContractParamsEntity < Grape::Entity
  expose :price, documentation: { type: 'Integer', desc: 'Contract price in cents' }
  expose :start_date, documentation: { type: 'DateTime', desc: 'Contract start date' }
  expose :end_date, documentation: { type: 'DateTime', desc: 'Contract end date' }
  expose :expiry_date, documentation: { type: 'DateTime', desc: 'Contract expiry date' }
end