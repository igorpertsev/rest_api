module V1
  class Authenticate < Grape::API
    format :json

    namespace :auth do
      desc 'Authenticate customer.'
      params do
        requires :email, type: String
        requires :password, type: String
      end
      post do
        command = ::AuthenticateUser.call(params[:email], params[:password])
        if command.success?
          { auth_token: command.result }
        else 
          error!('401 Unauthorized', 401)
        end
      end
    end
  end
end