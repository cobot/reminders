class Address
  include Virtus.model

  attribute :name, String
  attribute :company, String
  attribute :address, String
  attribute :city, String
  attribute :contry, String
  attribute :state, String
  attribute :post_code, String

  def first_name
    name.to_s.split[0]
  end

  def attributes
    super.merge(first_name: first_name)
  end
end
