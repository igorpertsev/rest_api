module V1
  class Imports < Grape::API
    format :json

    namespace :imports do
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

      desc 'Return status of import job.' do
        produces ['application/json']
        consumes ['application/json']
        success ::V1::ActiveJobStatusEntity.documentation
        failure [[401, 'Unauthorized']]
      end
      params do
        requires :job_id, type: String
      end
      post do
        command = JobStatus::Fetch.call(current_customer.id, params[:job_id])
        present command.result, with: ::V1::ActiveJobStatusEntity
      end
    end
  end
end