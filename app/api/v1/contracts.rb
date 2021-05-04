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

      desc 'Returns a list of contracts with filtering for customer.' do
        produces ['application/json']
        consumes ['application/json']
        failure [[401, 'Unauthorized customer']]
      end
      params do
        optional :end_date, type: Hash, desc: 'Filter description for end_date field'
        optional :expiry_date, type: Hash, desc: 'Filter description for expiry_date field'
        optional :start_date, type: Hash, desc: 'Filter description for start_date field'
        optional :price, type: Hash, desc: 'Filter description for price field'
      end
      get do
        present ::Contracts::Fetcher.new(customer: current_customer, options: params).run, with: ::V1::ContractEntity
      end

      desc 'Creates new contract for customer.' do
        produces ['application/json']
        consumes ['application/json']
        success ::V1::ContractEntity.documentation
        failure [[401, 'Unauthorized customer'], [422, 'Unprocessible entity']]
      end
      params do 
        requires :end_date, type: DateTime, desc: 'End date for contract'
        requires :expiry_date, type: DateTime, desc: 'Expiry date for contract'
        requires :start_date, type: DateTime, desc: 'Start date for contract'
        requires :price, type: Integer, desc: 'Contract price in cents'
      end
      post do
        command = ::Contracts::Create.call(@current_customer.id, params)
        if command.success?
          present command.result, with: ::V1::ContractEntity
        else 
          error!('422 Unprocessible', 422)
        end
      end

      desc 'Bulk create of new contracts for customer.' do
        produces ['application/json']
        consumes ['application/json']
        failure [[401, 'Unauthorized customer']]
      end
      params do 
        requires :contracts, type: Array[Hash], desc: 'List of new contracts data. Each line should include all fields from :create action',
          coerce_with: ->(val) { val.is_a?(Array) ? val : JSON.parse(val) }
      end
      post :import do 
        job_id = SecureRandom.hex(10)
        BulkImportJob.perform_later(job_id, @current_customer.id.to_s, params[:contracts])
        { job_id: job_id, status: :enqueued }
      end

      desc 'Updates existing contract for customer.' do
        produces ['application/json']
        consumes ['application/json']
        success ::V1::ContractEntity.documentation
        failure [[401, 'Unauthorized customer'], [422, 'Unprocessible entity']]
      end
      params do 
        requires :id, type: String, desc: 'Contract ID'
        optional :end_date, type: DateTime, desc: 'End date for contract'
        optional :expiry_date, type: DateTime, desc: 'Expiry date for contract'
        optional :start_date, type: DateTime, desc: 'Start date for contract'
        optional :price, type: Integer, desc: 'Contract price in cents'
      end
      patch do 
        command = ::Contracts::Update.call(@current_customer.id, params.delete(:id), params)
        if command.success?
          present command.result, with: ::V1::ContractEntity
        else 
          error!('422 Unprocessible', 422)
        end
      end

      desc 'Deletes existing contract for customer.' do
        produces ['application/json']
        consumes ['application/json']
        failure [[401, 'Unauthorized customer']]
      end 
      params do 
        requires :ids, type: Array[String], desc: 'Ids of contracts to be removed',
          coerce_with: -> (val) { (val.is_a?(Array) ? val : val.to_s.split(',').map(&:strip)) }
      end
      delete do 
        ::Contracts::Delete.call(@current_customer.id, params[:ids])
        { status: :ok }
      end
    end
  end
end