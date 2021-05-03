class Customer
  include Mongoid::Document

  field :name, type: String
  field :address, type: String
  field :email, type: String

  has_many :contracts
end