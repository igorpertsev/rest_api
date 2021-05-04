require 'rails_helper'

RSpec.describe JobStatus::Fetch do
  context 'job status exists' do
    subject { described_class.call(status.job_id) }
    
    let(:status) { create(:job_status) }

    it 'is successful' do 
      expect(subject.success?).to be_truthy
    end

    it 'returns status' do
      aggregate_failures do 
        expect(subject.result.job_id).to eq(status.job_id)
        expect(subject.result.success).to eq(status.success)
        expect(subject.result.fail_reasons).to eq(status.fail_reasons)
        expect(subject.result.successful_count).to eq(status.successful_count)
      end
    end
  end

  context 'job status doesnt exist' do
    subject { described_class.call('test') }

    it 'is successful' do 
      expect(subject.success?).to be_truthy
    end

    it 'returns default stub' do
      aggregate_failures do 
        expect(subject.result.job_id).to eq(nil)
        expect(subject.result.success).to be_nil
        expect(subject.result.fail_reasons).to be_empty
        expect(subject.result.successful_count).to be_zero
      end
    end
  end
end
