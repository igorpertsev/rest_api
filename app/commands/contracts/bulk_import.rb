module Contracts
  class BulkImport
    prepend SimpleCommand

    BATCH_SIZE = 1000
    
    def initialize(customer_id, contracts_data)
      @customer_id = customer_id
      @contracts_data = contracts_data
      @successful_count = 0
    end
    
    def call
      valid_contracts.in_groups_of(BATCH_SIZE, false) { |batch| ::Contract.create!(batch) }
      successful_count
    end
    
    private
    
    attr_accessor :customer_id, :contracts_data, :successful_count

    def valid_contracts
      contracts_data.map do |contract_data|
        contract = Contract.new(contract_data.merge(customer_id: customer_id))
        if contract.valid? 
          @successful_count += 1
          contract_data.merge!(customer_id: customer_id)
        else 
          add_errors(contract_data, contract)
          nil
        end
      end.compact
    end

    def add_errors(contract_data, contract)
      contract.errors.full_messages.each do |message| 
        errors.add contract_data, message
      end
    end
  end
end
