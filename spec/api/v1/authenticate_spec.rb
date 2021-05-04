require 'rails_helper'

RSpec.describe ::V1::Authenticate do
  let(:customer) { create(:customer, password: '123test') }

  context 'POST /api/auth' do
    context 'valid parameters' do 
      let(:params) { { email: customer.email, password: '123test' } } 

      it 'returns valid auth token' do
        post '/api/auth', params: params

        json_body = JSON.parse(response.body)

        aggregate_failures do 
          expect(response.status).to eq(201)
          expect(json_body['auth_token']).not_to be_nil
          expect(json_body['error']).to be_nil
        end
      end
    end

    context 'invalid parameters' do 
      let(:params) { { email: customer.email, password: 'wrong' } } 

      it 'returns 401' do
        post '/api/auth', params: params

        json_body = JSON.parse(response.body)
        aggregate_failures do 
          expect(response.status).to eq(401)
          expect(json_body['error']).to eq('401 Unauthorized')
          expect(json_body['auth_token']).to be_nil
        end
      end
    end

    context 'missing parameters' do 
      it 'returns 401' do
        post '/api/auth', params: {}

        json_body = JSON.parse(response.body)
        aggregate_failures do 
          expect(response.status).to eq(400)
          expect(json_body['error']).to eq('email is missing, password is missing')
        end
      end
    end
  end
end
