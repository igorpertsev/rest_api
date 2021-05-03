module Contracts
  module Filters
    module Contract
      class ExpiryDate < ::Contracts::Filters::Base
        private 
        
        def field
          'expiry_date'
        end
      end
    end
  end
end
