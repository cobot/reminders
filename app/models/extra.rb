class Extra
  include Virtus.model
  include Pricable

  attribute :name, String
  attribute :price_in_cents, Fixnum
  attribute :price, BigDecimal
  attribute :tax_rate, BigDecimal
  attribute :charge_taxes, Boolean

  def initialize(*args)
    super
  end

  def to_liquid
    attributes.stringify_keys
  end
end
