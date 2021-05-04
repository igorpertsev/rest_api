module Contracts
  class BulkImport
    prepend SimpleCommand
    
    def initialize(customer_id, contracts_data)
      @customer_id = customer_id
      @contracts_data = contracts_data
    end
    
    def call
      successful_count = 0
      contracts_data.each do |contract_data|
        command = ::Contracts::Create.call(customer_id, contract_data)
        if command.success?
          successful_count += 1
        else 
          command.errors.full_messages.each { |message| errors.add contract_data, message }
        end
      end
      successful_count
    end
    
    private
    
    attr_accessor :customer_id, :contracts_data
  end
end
