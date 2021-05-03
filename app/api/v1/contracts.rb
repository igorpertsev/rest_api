module V1
  class Contracts < Grape::API
    format :json

    namespace :contracts do
      helpers do 
        def current_customer
          @current_customer
        end

        def authenticate_request
          @current_customer = ::AuthorizeAPIRequest.call(request.headers).result
        
          error!('401 Unauthorized', 401) unless @current_customer
        end
      end

      before do 
        authenticate_request
      end

      desc 'Returns a list of contracts with filtering for customer.'
      params do
        optional :end_date, type: Hash, desc: 'Filter description for end_date field'
        optional :expiry_date, type: Hash, desc: 'Filter description for expiry_date field'
        optional :start_date, type: Hash, desc: 'Filter description for start_date field'
        optional :price, type: Hash, desc: 'Filter description for price field'
      end
      get do
        present ::Contracts::Fetcher.new(customer: current_customer, options: params).run, with: ::V1::ContractEntity
      end

      desc 'Creates new contract for customer.' 
      params do 
        requires :end_date, type: DateTime, desc: 'End date for contract'
        requires :expiry_date, type: DateTime, desc: 'Expiry date for contract'
        requires :start_date, type: DateTime, desc: 'Start date for contract'
        requires :price, type: Integer, desc: 'Contract price in cents'
      end
      post do 
      end

      desc 'Bulk create of new contracts for customer.' 
      params do 
        requires :options, type: Array, desc: 'List of new contracts data. Should include all fields from :create action'
      end
      post do 
      end

      desc 'Updates existing contract for customer.' 
      params do 
        requires :id, type: String, desc: 'Contract ID'
        optional :end_date, type: DateTime, desc: 'End date for contract'
        optional :expiry_date, type: DateTime, desc: 'Expiry date for contract'
        optional :start_date, type: DateTime, desc: 'Start date for contract'
        optional :price, type: Integer, desc: 'Contract price in cents'
      end
      patch do 
      end

      desc 'Deletes existing contract for customer.' 
      params do 
        requires :id, type: Array, desc: 'Ids of contracts to be removed'
      end
      delete do 
      end
    end
  end
end