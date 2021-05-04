class V1::CustomerEntity < Grape::Entity
  expose :name, documentation: { type: 'String', desc: 'Customer name' }
  expose :email, documentation: { type: 'String', desc: 'Customer email' }
  expose :address, documentation: { type: 'String', desc: 'Customer address' }
end