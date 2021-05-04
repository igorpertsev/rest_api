require 'rails_helper'

RSpec.describe AuthorizeAPIRequest do
  describe '#call' do 
    subject { described_class.call(headers) }

    let(:customer) { create(:customer, password: '123test') }
    let(:time_now) { Time.local(2021, 4, 1, 12, 0, 0) }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    before { Timecop.freeze(time_now) }
    after { Timecop.return }

    context 'expired token' do 
      let(:token) { JsonWebToken.encode({ customer_id: customer.id.to_s }, 2.days.ago) }

      it 'is successful' do 
        expect(subject.success?).to be_truthy
      end

      it 'returns nil' do 
        expect(subject.result).to be_nil
      end
    end

    context 'valid token' do 
      let(:token) { JsonWebToken.encode(customer_id: customer.id.to_s) }

      it 'is successful' do 
        expect(subject.success?).to be_truthy
      end

      it 'returns valid customer' do 
        expect(subject.result).to eq(customer)
      end
    end

    context 'invalid token' do
      let(:token) { 'invalid' }

      it 'is successful' do 
        expect(subject.success?).to be_truthy
      end

      it 'returns nil' do 
        expect(subject.result).to be_nil
      end
    end

    context 'header is missing' do 
      let(:headers) { {} }

      it 'is not successful' do 
        expect(subject.success?).to be_falsey
      end

      it 'returns nil' do 
        expect(subject.result).to be_nil
      end
    end
  end
end
