class Plan
  include Virtus::ValueObject

  attribute :name, String
  attribute :price_per_cycle_in_cents, Fixnum
  attribute :price_per_cycle, BigDecimal
  attribute :currency, String
  attribute :canceled_to, Date
  attribute :extras, [Extra], default: []

  def initialize(*args)
    super
    self.price_per_cycle = BigDecimal.new(price_per_cycle_in_cents.to_s) / 100.0
  end

  def free?
    price_per_cycle == 0
  end

  def attributes
    super.merge(has_extras: !extras.empty?)
  end
end
