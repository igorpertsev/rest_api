require 'rails_helper'

RSpec.describe Contracts::BulkImport do
  let(:customer) { create(:customer, password: '123test') }

  describe '#call' do 
    subject { described_class.call(customer.id.to_s, params) }

    context 'valid parameters' do 
      let(:params) do 
        [
          {
            price: Faker::Number.number(digits: 5), 
            start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since)
          }, {
            price: Faker::Number.number(digits: 2), 
            start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since)
          }
        ]
      end

      it 'is successful' do
        expect(subject.success?).to be_truthy
      end

      it 'creates new contracts' do 
        expect { subject }.to change { Contract.count }.by(2)
      end

      it 'returns amount of imported contracts' do 
        expect(subject.result).to eq(2)
      end

      it 'creates contracts with valid attributes' do 
        subject
        params.each do |contracts_data|
          expect(::Contract.where(contracts_data).count).to eq(1)
        end
      end
    end

    context 'invalid parameters' do 
      let(:params) do 
        [
          {
            price: -5, 
            start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since)
          }, {
            price: Faker::Number.number(digits: 2), 
            start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since)
          }
        ]
      end

      it 'is not successful' do
        expect(subject.success?).to be_falsey
      end

      it 'creates only valid contracts' do 
        expect { subject }.to change { Contract.count }.by(1)
      end

      it 'returns amount of imported contracts' do 
        expect(subject.result).to eq(1)
      end

      it 'imports contracts with correct data' do 
        subject
        contracts_data = params.last 
        expect(::Contract.where(contracts_data).count).to eq(1)
      end

      it 'returns errors for contracts' do 
        reason = "#{params.first.to_s} Price must be greater than or equal to 0"
        expect(subject.errors.full_messages.count).to eq(1)
        expect(subject.errors.full_messages.first).to eq(reason)
      end
    end
  end
end
