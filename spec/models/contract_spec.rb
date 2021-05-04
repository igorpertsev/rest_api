require 'rails_helper'

RSpec.describe Contract, type: :model do
  subject { described_class.new }

  it 'validates presence of :price' do 
    expect(subject.valid?).to be_falsey
    expect(subject.errors.full_messages).to include('Price can\'t be blank')
  end

  it 'validates presence of :end_date' do 
    expect(subject.valid?).to be_falsey
    expect(subject.errors.full_messages).to include('End date can\'t be blank')
  end

  it 'validates presence of :start_date' do 
    expect(subject.valid?).to be_falsey
    expect(subject.errors.full_messages).to include('Start date can\'t be blank')
  end

  it 'validates presence of :expiry_date' do 
    expect(subject.valid?).to be_falsey
    expect(subject.errors.full_messages).to include('Expiry date can\'t be blank')
  end

  it 'validates presence of :customer' do 
    expect(subject.valid?).to be_falsey
    expect(subject.errors.full_messages).to include('Customer can\'t be blank')
  end

  context 'price numbericality' do 
    it 'validates numericality of :price' do 
      item = described_class.new(price: 'test')
      expect(item.valid?).to be_falsey
      expect(item.errors.full_messages).to include('Price is not a number')
    end

    it 'validates :price is greater or equal to zero' do 
      item = described_class.new(price: -1)
      expect(item.valid?).to be_falsey
      expect(item.errors.full_messages).to include('Price must be greater than or equal to 0')
    end

    it 'validates :price is integer' do 
      item = described_class.new(price: 5.5)
      expect(item.valid?).to be_falsey
      expect(item.errors.full_messages).to include('Price must be an integer')
    end
  end
end
