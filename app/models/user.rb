class User
  include Virtus::ValueObject

  attribute :email, String
end
