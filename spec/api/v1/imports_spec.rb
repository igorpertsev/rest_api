require 'rails_helper'

RSpec.describe ::V1::Imports do
  let(:customer) { create(:customer, password: '123test') }
  let(:token) { JsonWebToken.encode(customer_id: customer.id) }
  let(:job_status) { create(:job_status) }

  context 'GET /api/imports' do
    context 'with valid auth token' do 
      context 'valid job id' do 
        it 'returns status of job' do
          get '/api/imports',  headers: { 'Authorization' => "Bearer #{token}" }, params: { job_id: job_status.job_id }

          json_body = JSON.parse(response.body)
          aggregate_failures do 
            expect(response.status).to eq(200)
            expect(json_body['status']).to eq('success')
            expect(json_body['fail_reasons']).to be_empty
            expect(json_body['successful_count']).to eq(job_status.successful_count)
            expect(json_body['job_id']).to eq(job_status.job_id)
          end
        end
      end

      context 'invalid job id' do 
        it 'returns status of default job' do
          get '/api/imports',  headers: { 'Authorization' => "Bearer #{token}" }, params: { job_id: 'wrong' }

          json_body = JSON.parse(response.body)
          aggregate_failures do 
            expect(response.status).to eq(200)
            expect(json_body['status']).to eq('not finished')
            expect(json_body['fail_reasons']).to be_empty
            expect(json_body['successful_count']).to eq(0)
            expect(json_body['job_id']).to eq(nil)
          end
        end
      end

      context 'missing job id' do 
        it 'returns 400 error' do
          get '/api/imports',  headers: { 'Authorization' => "Bearer #{token}" }

          json_body = JSON.parse(response.body)
          aggregate_failures do 
            expect(response.status).to eq(400)
            expect(json_body['error']).to eq('job_id is missing')
          end
        end
      end
    end

    context 'with invalid auth token' do 
      context 'token is wrong' do
        let(:token) { 'wrong' }

        it 'returns 401' do
          get '/api/imports', headers: { 'Authorization' => "Bearer #{token}" }

          json_body = JSON.parse(response.body)
          aggregate_failures do 
            expect(response.status).to eq(401)
            expect(json_body['error']).to eq('401 Unauthorized')
          end
        end
      end

      context 'token is missing' do
        it 'returns 401' do
          get '/api/imports'

          json_body = JSON.parse(response.body)
          aggregate_failures do 
            expect(response.status).to eq(401)
            expect(json_body['error']).to eq('401 Unauthorized')
          end
        end
      end
    end
  end
end
