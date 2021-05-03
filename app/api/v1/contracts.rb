module V1
  class Contracts < Grape::API
    format :json

    namespace :contracts do
      desc 'Returns a list of all contracts for customer.'
      params do
        requires :customer_id, type: String
      end
      get :customer_id do
        present Contract.where(customer_id: params[:customer_id]), with: ::V1::ContractEntity
      end

      desc 'Returns all contracts.'
      get do
        present Contract.all, with: ::V1::ContractEntity
      end
    end
  end
end