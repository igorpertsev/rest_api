class Contract
  include Mongoid::Document

  field :price, type: Integer
  field :start_date, type: DateTime
  field :end_date, type: DateTime
  field :expiry_date, type: DateTime

  belongs_to :customer
end
