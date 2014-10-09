class Plan
  include Virtus::ValueObject

  attribute :name, String
  attribute :price_per_cycle_in_cents, Fixnum
  attribute :price_per_cycle, BigDecimal
  attribute :price_per_cycle_without_extras, BigDecimal
  attribute :currency, String
  attribute :canceled_to, Date
  attribute :extras, [Extra], default: []

  def initialize(*args)
    super
    self.price_per_cycle = BigDecimal.new(price_per_cycle_in_cents.to_s) / 100.0
    self.price_per_cycle_without_extras = price_per_cycle - extras.map(&:price).sum
  end

  def free?
    price_per_cycle == 0
  end
end
