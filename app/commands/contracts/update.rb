module Contracts
  class Update
    prepend SimpleCommand
    
    def initialize(customer_id, contract_id, options)
      @customer_id = customer_id
      @contract_id = contract_id
      @options = options
    end
    
    def call
      contract = ::Contract.where(customer_id: customer_id, id: contract_id).first
      if contract.present?
        contract.attributes = options.slice(:start_date, :end_date, :expiry_date, :price)
        if contract.valid?
          contract.save!
        else
          contract.errors.full_messages.each { |x| errors.add :message, x }
          contract.reload
        end  
      else
        errors.add :message, 'Not found'
      end
      contract
    end
    
    private
    
    attr_accessor :customer_id, :contract_id, :options
  end
end
