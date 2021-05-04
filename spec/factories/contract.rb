FactoryBot.define do
  factory :contract, class: Contract do
    customer 
    price { Faker::Number.number(digits: 5) }
    start_date { Faker::Time.between(from: 10.days.ago, to: 10.days.since) }
    end_date { Faker::Time.between(from: 10.days.ago, to: 10.days.since) }
    expiry_date { Faker::Time.between(from: 10.days.ago, to: 30.days.since) }
  end
end