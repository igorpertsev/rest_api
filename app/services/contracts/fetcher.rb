module Contracts
  class Fetcher
    attr_reader :options
    attr_accessor :scope

    def initialize(options: {})
      @options = options
      @scope = Contract.all
    end

    def run
      price_filter if options[:price]
      end_date_filter if options[:end_date]
      start_date_filter if options[:start_date]
      expiry_date_filter if options[:expiry_date]
      scope
    end

    def price_filter
      @scope = Contracts::Filters::Contract::Price.new(scope, options[:price]).apply
    end

    def end_date_filter
      @scope = Contracts::Filters::Contract::EndDate.new(scope, options[:end_date]).apply
    end

    def start_date_filter
      @scope = Contracts::Filters::Contract::StartDate.new(scope, options[:start_date]).apply
    end

    def expiry_date_filter
      @scope = Contracts::Filters::Contract::ExpiryDate.new(scope, options[:expiry_date]).apply
    end
  end
end
