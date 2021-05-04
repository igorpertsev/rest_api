class Customer
  include Mongoid::Document
  devise :database_authenticatable, :registerable, :validatable

  field :encrypted_password, type: String, default: ''

  field :name, type: String
  field :address, type: String
  field :email, type: String

  has_many :contracts

  validates_presence_of :email, :name
  validates_uniqueness_of :name
end
