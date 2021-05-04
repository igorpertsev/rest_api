require 'faker'

class AddSeedData < Mongoid::Migration
  def self.up
    customer = Customer.where(name: 'swagger', address: 'none', password: '123qweASD', email: 'swagger@swagger.com').first_or_create
    10.times do 
      Contract.create(price: Faker::Number.number(digits: 5), 
        start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
        end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
        expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since),
        customer_id: customer.id)
    end

    5.times do 
      customer = Customer.where(name: Faker::Name.name , address: Faker::Address.full_address, 
        password: '123qweASD', email: Faker::Internet.email).first_or_create
      10.times do 
        Contract.create(price: Faker::Number.number(digits: 5), 
          start_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
          end_date: Faker::Time.between(from: 10.days.ago, to: 10.days.since),
          expiry_date: Faker::Time.between(from: 10.days.ago, to: 30.days.since),
          customer_id: customer.id)
      end
    end
  end

  def self.down
    Customer.all.destroy_all
  end
end