require 'rails_helper'

RSpec.describe BulkImportJob, type: :job do
  subject { described_class.new.perform(job_id, customer.id, params) }

  let(:job_id) { SecureRandom.hex(5) }
  let(:customer) { create(:customer) }
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

  it 'imports correct contracts amount' do 
    expect { subject }.to change { ::Contract.count }.by(2) 
  end

  it 'imports contracts with correct data' do 
    subject
    params.each do |contracts_data|
      expect(::Contract.where(contracts_data).count).to eq(1)
    end
  end

  it 'creates job status instace after it finished' do 
    expect { subject }.to change { ::ActiveJobStatus.count }.by(1)
  end

  it 'set correct job status instace values' do 
    subject
    status = ::ActiveJobStatus.last
    aggregate_failures do 
      expect(status.success).to be_truthy
      expect(status.fail_reasons).to be_empty
      expect(status.successful_count).to eq(2) 
      expect(status.job_id).to eq(job_id)
    end
  end

  context 'incorrect data passed' do 
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

    it 'imports only valid contracts' do 
      expect { subject }.to change { ::Contract.count }.by(1) 
    end

    it 'imports contracts with correct data' do 
      subject
      contracts_data = params.last 
      expect(::Contract.where(contracts_data).count).to eq(1)
    end

    it 'set correct job status instace values' do 
      subject
      status = ::ActiveJobStatus.last
      reason = "#{params.first.to_s} Price must be greater than or equal to 0"
      aggregate_failures do 
        expect(status.success).to be_falsey
        expect(status.fail_reasons).not_to be_empty
        expect(status.fail_reasons.first).to eq(reason)
        expect(status.successful_count).to eq(1) 
        expect(status.job_id).to eq(job_id)
      end
    end
  end
end
