require 'rails_helper'

RSpec.describe ActiveJobStatus, type: :model do
  it 'sets default success value if not present' do 
    expect(described_class.new.success).to be_nil
  end

  it 'sets default fail reason value if not present' do 
    expect(described_class.new.fail_reasons).to be_empty
  end

  it 'sets default successful_count value if not present' do 
    expect(described_class.new.successful_count).to eq(0)
  end

  it 'requires job_id field' do 
    status = described_class.new
    expect(status.valid?).to be_falsey
    expect(status.errors.full_messages).to include('Job can\'t be blank')
  end
end
