require 'rails_helper'

RSpec.describe Contracts::Create do
  let(:customer) { create(:customer, password: '123test') }

  describe '#call' do 
    subject { described_class.call(customer.id.to_s, options) }

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

      it 'creates new contract' do 
        expect { subject }.to change { Contract.count }.by(1)
      end

      it 'returns created contract' do 
        expect(subject.result.class).to eq(Contract)
      end

      it 'creates contract with valid attributes' do 
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

      it 'doesnt create new contract' do 
        expect { subject }.not_to change { Contract.count }
      end

      it 'returns build contract' do 
        expect(subject.result.class).to eq(Contract)
      end

      it 'doesnt save contract' do 
        expect(subject.result.persisted?).to be_falsey
      end

      it 'includes all errors' do 
        expect(subject.errors.full_messages.size).to eq(1) 
        expect(subject.errors.full_messages).to include('Message Price must be greater than or equal to 0')
      end
    end
  end
end
