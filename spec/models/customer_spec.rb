require 'rails_helper'

RSpec.describe Customer, type: :model do
  context 'validate presence of ' do 
    subject { described_class.new }

    it ':email' do 
      expect(subject.valid?).to be_falsey
      expect(subject.errors.full_messages).to include('Email can\'t be blank')
    end

    it ':name' do 
      expect(subject.valid?).to be_falsey
      expect(subject.errors.full_messages).to include('Name can\'t be blank')
    end

    it ':password' do 
      expect(subject.valid?).to be_falsey
      expect(subject.errors.full_messages).to include('Password can\'t be blank')
    end
  end

  context 'validate uniquenes of ' do 
    subject { described_class.new(params) }

    let(:params) { { email: 'test@test.com', name: 'test', password: '123qweasd' } }

    it ':email' do 
      described_class.create(params)
      expect(subject.valid?).to be_falsey
      expect(subject.errors.full_messages).to include('Email is already taken')
    end

    it ':name' do 
      described_class.create(params)
      expect(subject.valid?).to be_falsey
      expect(subject.errors.full_messages).to include('Name is already taken')
    end
  end
end
