FactoryBot.define do
  factory :customer, class: Customer do
    name { Faker::Name.name }
    address { Faker::Address.full_address }
    password { '123qweASD' }
    email { Faker::Internet.email }
  end
end