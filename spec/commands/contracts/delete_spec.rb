require 'rails_helper'

RSpec.describe Contracts::Delete do
  let(:customer) { create(:customer, password: '123test') }
  let!(:contract_1) { create(:contract, customer: customer) }
  let!(:contract_2) { create(:contract, customer: customer) }

  describe '#call' do 
    subject { described_class.call(customer.id.to_s, ids) }

    context 'ids is array' do 
      let(:ids) { [contract_1.id.to_s, contract_2.id.to_s] }

      it 'is successful' do
        expect(subject.success?).to be_truthy
      end

      it 'removes existing contracts' do 
        expect { subject }.to change { Contract.count }.from(2).to(0)
      end
    end

    context 'ids is integer' do 
      let(:ids) { contract_1.id.to_s }

      it 'is successful' do
        expect(subject.success?).to be_truthy
      end

      it 'removes existing contracts' do 
        expect { subject }.to change { Contract.count }.from(2).to(1)
      end
    end
  end
end
