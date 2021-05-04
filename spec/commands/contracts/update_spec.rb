require 'rails_helper'

RSpec.describe Contracts::Update do
  let(:customer) { create(:customer, password: '123test') }
  let!(:contract) { create(:contract, customer: customer) }

  describe '#call' do 
    subject { described_class.call(customer.id.to_s, contract_id, options) }

    context 'contract not exists' do 
      let(:options) do 
        {
          price: Faker::Number.number(digits: 5),
          start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
          end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
          expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since)
        }
      end
      let(:contract_id) { 'wrong' }

      it 'is not successful' do
        expect(subject.success?).to be_falsey
      end

      it 'doesnt update contract' do 
        expect { subject }.not_to change { contract }
      end

      it 'includes all errors' do 
        expect(subject.errors.full_messages.size).to eq(1) 
        expect(subject.errors.full_messages).to include('Message Not found')
      end
    end

    context 'contract exists' do 
      let(:contract_id) { contract.id } 

      context 'valid parameters' do
        let(:options) do 
          {
            price: Faker::Number.number(digits: 5),
            start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since)
          }
        end

        it 'is successful' do
          expect(subject.success?).to be_truthy
        end

        it 'returns updated contract' do 
          expect(subject.result.class).to eq(Contract)
          aggregate_failures do 
            options.each do |field, value|
              expect(subject.result.send(field)).to eq(value)
            end
          end
        end
      end

      context 'invalid parameters' do 
        let(:options) do 
          {
            price: -5,
            start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
            expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since)
          }
        end

        it 'is not successful' do
          expect(subject.success?).to be_falsey
        end

        it 'returns unchanged contract' do 
          expect(subject.result.class).to eq(Contract)
          
          aggregate_failures do 
            options.each do |field, value|
              expect(subject.result.send(field)).not_to eq(value)
            end
          end
        end

        it 'includes all errors' do 
          expect(subject.errors.full_messages.size).to eq(1) 
          expect(subject.errors.full_messages).to include('Message Price must be greater than or equal to 0')
        end
      end
    end
  end
end
