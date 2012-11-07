class Plan
  include Virtus::ValueObject

  attribute :name, String
  attribute :price_per_cycle, BigDecimal
  attribute :currency, String
end
