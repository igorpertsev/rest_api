require 'rails_helper'

RSpec.describe AuthenticateUser do
  describe '#call' do 
    subject { described_class.call(email, password) }

    let(:customer) { create(:customer, password: '123test') }
    let(:time_now) { Time.local(2021, 4, 1, 12, 0, 0) }

    before { Timecop.freeze(time_now) }
    after { Timecop.return }

    context 'valid customer' do 
      let(:email) { customer.email }
      let(:password) { '123test' }

      it 'is successful' do 
        expect(subject.success?).to be_truthy
      end

      it 'returns valid token' do 
        expect(subject.result).not_to be_nil
        expect(JsonWebToken.decode(subject.result)[:customer_id]).to eq(customer.id.to_s)
      end
    end

    context 'invalid customer' do
      let(:email) { customer.email }
      let(:password) { 'wrong' }

      it 'is not successful' do 
        expect(subject.success?).to be_falsey
      end

      it 'returns nil' do 
        expect(subject.result).to be_nil
      end

      it 'contains error message' do 
        expect(subject.errors.full_messages).to include('Message Invalid email / password')
      end
    end
  end
end
