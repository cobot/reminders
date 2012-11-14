class Address
  include Virtus::ValueObject

  attribute :name, String
  attribute :company, String
  attribute :address, String
  attribute :city, String
  attribute :contry, String
  attribute :state, String
  attribute :post_code, String
end
