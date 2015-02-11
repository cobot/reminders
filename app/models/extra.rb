class Extra
  include Virtus.model

  attribute :name, String
  attribute :price_in_cents, Fixnum
  attribute :price, BigDecimal

  def initialize(*args)
    super
    self.price = BigDecimal.new(price_in_cents.to_s) / 100.0
  end

  def to_liquid
    attributes.stringify_keys
  end
end
