module Contracts
  class Delete
    prepend SimpleCommand
    
    def initialize(customer_id, contract_ids)
      @customer_id = customer_id
      @contract_ids = contract_ids
    end
    
    def call
      ::Contract.where(customer_id: customer_id, id: { '$in' => contract_ids }).destroy_all
    end
    
    private
    
    attr_accessor :customer_id, :contract_ids
  end
end
