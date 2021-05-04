class Contract
  include Mongoid::Document

  field :price, type: Integer
  field :start_date, type: DateTime
  field :end_date, type: DateTime
  field :expiry_date, type: DateTime

  belongs_to :customer

  validates_presence_of :price, :start_date, :end_date, :expiry_date, :customer_id
  validates_numericality_of :price, only_integer: true, greater_than_or_equal_to: 0
end
