module Contracts
  class Create
    prepend SimpleCommand
    
    def initialize(customer_id, parameters)
      @customer_id = customer_id
      @parameters = parameters
    end
    
    def call
      contract = ::Contract.new(parameters.merge(customer_id: customer_id))
      contract.valid? ? contract.save! : contract.errors.each { |error| errors.add(:message, error) }
      contract
    end
    
    private
    
    attr_accessor :customer_id, :parameters
  end
end
