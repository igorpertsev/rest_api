require 'rails_helper'

RSpec.describe ::V1::Imports do
  let(:customer) { create(:customer, password: '123test') }
  let(:token) { JsonWebToken.encode(customer_id: customer.id) }
  let(:time_now) { Time.local(2021, 4, 1, 12, 0, 0) }

  before { Timecop.freeze(time_now) }
  after { Timecop.return }

  shared_examples 'with invalid auth token' do |path, method|
    context 'with invalid auth token' do 
      context 'token is wrong' do
        let(:token) { 'wrong' }

        it 'returns 401' do
          send(method, path, headers: { 'Authorization' => "Bearer #{token}" })

          json_body = JSON.parse(response.body)
          aggregate_failures do 
            expect(response.status).to eq(401)
            expect(json_body['error']).to eq('401 Unauthorized')
          end
        end
      end

      context 'token is missing' do
        it 'returns 401' do
          send(method, path)

          json_body = JSON.parse(response.body)
          aggregate_failures do 
            expect(response.status).to eq(401)
            expect(json_body['error']).to eq('401 Unauthorized')
          end
        end
      end
    end
  end

  context 'GET /api/contracts' do
    include_examples 'with invalid auth token', '/api/contracts', 'get'

    let!(:valid_contract_1) do
      create(:contract, customer: customer, price: 10, start_date: 5.days.ago, end_date: 5.days.since, expiry_date: 5.days.since)
    end
    let!(:valid_contract_2) do 
      create(:contract, customer: customer, price: 20, start_date: 3.days.ago, end_date: 3.days.since, expiry_date: 3.days.since)
    end
    let!(:invalid_contract) do 
      create(:contract, price: 20, start_date: 3.days.ago, end_date: 3.days.since, expiry_date: 3.days.since)
    end

    it 'returns list of contracts for customer' do 
      get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" }

      ids = JSON.parse(response.body).map { |x| x['id'] }
      aggregate_failures do 
        expect(ids.size).to eq(2) 
        expect(ids).to include(valid_contract_1.id.to_s)
        expect(ids).to include(valid_contract_2.id.to_s)
        expect(ids).not_to include(invalid_contract.id.to_s)
      end
    end

    context 'filter by price' do 
      it 'filter by gt' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { price: { c: 'gt', v: 15 } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by lt' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { price: { c: 'lt', v: 15 } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).to include(valid_contract_1.id.to_s)
          expect(ids).not_to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by gte' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { price: { c: 'gte', v: 20 } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by lte' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { price: { c: 'lte', v: 10 } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).to include(valid_contract_1.id.to_s)
          expect(ids).not_to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by eq' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { price: { c: 'eq', v: 20 } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end
    end

    context 'filter by start_date' do 
      it 'filter by gt' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { start_date: { c: 'gt', v: 4.days.ago } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by lt' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { start_date: { c: 'lt', v: 4.days.ago } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).to include(valid_contract_1.id.to_s)
          expect(ids).not_to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by gte' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { start_date: { c: 'gte', v: 3.days.ago } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by lte' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { start_date: { c: 'lte', v: 5.days.ago } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).to include(valid_contract_1.id.to_s)
          expect(ids).not_to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by eq' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { start_date: { c: 'eq', v: 3.days.ago } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end
    end

    context 'filter by end_date' do 
      it 'filter by gt' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { end_date: { c: 'gt', v: 4.days.since } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).to include(valid_contract_1.id.to_s)
          expect(ids).not_to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by lt' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { end_date: { c: 'lt', v: 4.days.since } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by gte' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { end_date: { c: 'gte', v: 5.days.since } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).to include(valid_contract_1.id.to_s)
          expect(ids).not_to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by lte' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { end_date: { c: 'lte', v: 3.days.since } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by eq' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { end_date: { c: 'eq', v: 3.days.since } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end
    end

    context 'filter by expiry_date' do 
      it 'filter by gt' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { expiry_date: { c: 'gt', v: 4.days.since } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).to include(valid_contract_1.id.to_s)
          expect(ids).not_to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by lt' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { expiry_date: { c: 'lt', v: 4.days.since } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by gte' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { expiry_date: { c: 'gte', v: 5.days.since } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).to include(valid_contract_1.id.to_s)
          expect(ids).not_to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by lte' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { expiry_date: { c: 'lte', v: 3.days.since } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end

      it 'filter by eq' do
        get '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" },
          params: { expiry_date: { c: 'eq', v: 3.days.since } }

        ids = JSON.parse(response.body).map { |x| x['id'] }
        aggregate_failures do 
          expect(ids.size).to eq(1) 
          expect(ids).not_to include(valid_contract_1.id.to_s)
          expect(ids).to include(valid_contract_2.id.to_s)
          expect(ids).not_to include(invalid_contract.id.to_s)
        end
      end
    end
  end

  context 'POST /api/contracts' do
    include_examples 'with invalid auth token', '/api/contracts', 'post'

    context 'missing parameters' do 
      it 'returns 400 error' do
        post '/api/contracts', params: {}, headers: { 'Authorization' => "Bearer #{token}" }

        json_body = JSON.parse(response.body)
        byebug

        aggregate_failures do 
          expect(response.status).to eq(400)
          expect(json_body['error']).to eq('end_date is missing, expiry_date is missing, start_date is missing, price is missing')
        end
      end
    end

    context 'valid parameters' do 
      let(:params) do 
        {
          price: Faker::Number.number(digits: 5), 
          start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
          end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
          expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since).strftime('%FT%T.%L%:z')
        }
      end

      it 'returns valid json response' do
        post '/api/contracts', params: params, headers: { 'Authorization' => "Bearer #{token}" }

        json_body = JSON.parse(response.body)
        aggregate_failures do 
          expect(response.status).to eq(201)
          expect(json_body['price']).to eq(params[:price])
          expect(json_body['start_date']).to eq(params[:start_date])
          expect(json_body['end_date']).to eq(params[:end_date])
          expect(json_body['expiry_date']).to eq(params[:expiry_date])
          expect(json_body['customer']['name']).to eq(customer.name)
          expect(json_body['customer']['email']).to eq(customer.email)
          expect(json_body['customer']['address']).to eq(customer.address)
        end
      end

      it 'creates new contract' do
        expect {
          post '/api/contracts', params: params, headers: { 'Authorization' => "Bearer #{token}" }
        }.to change { Contract.count }.by(1)
      end
    end

    context 'invalid parameters' do 
      let(:params) do 
        {
          price: -5, 
          start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
          end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
          expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since).strftime('%FT%T.%L%:z')
        }
      end

      it 'returns error response' do
        post '/api/contracts', params: params, headers: { 'Authorization' => "Bearer #{token}" }

        json_body = JSON.parse(response.body)
        aggregate_failures do 
          expect(response.status).to eq(422)
        end
      end

      it 'doesnt new contract' do
        expect {
          post '/api/contracts', params: params, headers: { 'Authorization' => "Bearer #{token}" }
        }.not_to change { Contract.count }
      end
    end
  end

  context 'POST /api/contracts/import' do
    include_examples 'with invalid auth token', '/api/contracts/import', 'post'

    context 'missing parameters' do 
      it 'returns 400 error' do
        post '/api/contracts/import', params: {}, headers: { 'Authorization' => "Bearer #{token}" }

        json_body = JSON.parse(response.body)
        aggregate_failures do 
          expect(response.status).to eq(400)
          expect(json_body['error']).to eq('contracts is missing')
        end
      end
    end

    context 'valid parameters' do 
      let(:params) do 
        {
          contracts: [{
            price: Faker::Number.number(digits: 5).to_s, 
            start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
            end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
            expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since).strftime('%FT%T.%L%:z')
          }.stringify_keys, {
            price: Faker::Number.number(digits: 5).to_s, 
            start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
            end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
            expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since).strftime('%FT%T.%L%:z')
          }.stringify_keys]
        }
      end

      it 'returns job id in response' do
        post '/api/contracts/import', params: params, headers: { 'Authorization' => "Bearer #{token}" }

        json_body = JSON.parse(response.body)
        aggregate_failures do 
          expect(response.status).to eq(201)
          expect(json_body['job_id']).not_to be_nil
        end
      end

      it 'enqueues background job' do
        expect(BulkImportJob).to receive(:perform_later).with(anything, customer.id.to_s, params[:contracts])
        post '/api/contracts/import', params: params, headers: { 'Authorization' => "Bearer #{token}" }
      end
    end
  end

  context 'PATCH /api/contracts' do
    include_examples 'with invalid auth token', '/api/contracts', 'patch'

    let(:contract) { create(:contract, customer: customer) }

    context 'missing parameters' do 
      it 'returns 400 error' do
        patch '/api/contracts', params: {}, headers: { 'Authorization' => "Bearer #{token}" }

        json_body = JSON.parse(response.body)
        aggregate_failures do 
          expect(response.status).to eq(400)
          expect(json_body['error']).to eq('id is missing')
        end
      end
    end

    context 'valid parameters' do 
      let(:params) do 
        {
          id: contract.id.to_s,
          price: Faker::Number.number(digits: 5), 
          start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
          end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
          expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since).strftime('%FT%T.%L%:z')
        }
      end

      it 'returns valid json response' do
        patch '/api/contracts', params: params, headers: { 'Authorization' => "Bearer #{token}" }

        json_body = JSON.parse(response.body)
        aggregate_failures do 
          expect(response.status).to eq(200)
          expect(json_body['price']).to eq(params[:price])
          expect(json_body['start_date']).to eq(params[:start_date])
          expect(json_body['end_date']).to eq(params[:end_date])
          expect(json_body['expiry_date']).to eq(params[:expiry_date])
          expect(json_body['customer']['name']).to eq(customer.name)
          expect(json_body['customer']['email']).to eq(customer.email)
          expect(json_body['customer']['address']).to eq(customer.address)
        end
      end

      it 'updates contract' do
        patch '/api/contracts', params: params, headers: { 'Authorization' => "Bearer #{token}" }
        contract.reload
        aggregate_failures do 
          params.except(:id).each { |x, v| expect(contract.send(x)).to eq(v) }
        end
      end
    end

    context 'invalid parameters' do 
      let(:params) do 
        {
          id: contract.id.to_s,
          price: -5, 
          start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
          end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since).strftime('%FT%T.%L%:z'),
          expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since).strftime('%FT%T.%L%:z')
        }
      end

      it 'returns error response' do
        patch '/api/contracts', params: params, headers: { 'Authorization' => "Bearer #{token}" }

        json_body = JSON.parse(response.body)
        aggregate_failures do 
          expect(response.status).to eq(422)
        end
      end

      it 'doesnt update contract' do
        patch '/api/contracts', params: params, headers: { 'Authorization' => "Bearer #{token}" }
        contract.reload
        aggregate_failures do 
          params.each { |x, v| expect(contract.send(x)).not_to eq(v) }
        end
      end
    end
  end

  context 'DELETE /api/contracts' do
    include_examples 'with invalid auth token', '/api/contracts', 'delete'

    context 'missing parameters' do 
      it 'returns 400 error' do
        delete '/api/contracts', headers: { 'Authorization' => "Bearer #{token}" }

        json_body = JSON.parse(response.body)
        aggregate_failures do 
          expect(response.status).to eq(400)
          expect(json_body['error']).to eq('ids is missing')
        end
      end
    end

    context 'valid parameters' do 
      let!(:contract_1) { create(:contract, customer: customer) }
      let!(:contract_2) { create(:contract, customer: customer) }

      it 'removes contracts by id' do
        expect {
          delete '/api/contracts', params: { ids: [contract_1.id.to_s, contract_2.id.to_s] }, 
            headers: { 'Authorization' => "Bearer #{token}" }
        }.to change { Contract.count }.from(2).to(0)
      end
    end
  end
end
