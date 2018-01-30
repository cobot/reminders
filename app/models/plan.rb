class Plan
  include Virtus.model
  include Pricable

  attribute :name, String
  attribute :price_per_cycle_in_cents, Integer
  attribute :price, BigDecimal
  attribute :currency, String
  attribute :canceled_to, Date
  attribute :extras, [Extra], default: []
  attribute :tax_rate, BigDecimal
  attribute :charge_taxes, Boolean

  # Backwards compability with api still using price_per_cycle_in_cents
  alias_method :price_in_cents, :price_per_cycle_in_cents

  # Backwards compability with old templates that use price_per_cycle instead of price
  attribute :price_per_cycle, BigDecimal
  def price_per_cycle
    price
  end

  def initialize(attributes)
    attributes[:extras].each{|extra| extra[:charge_taxes] = attributes[:charge_taxes]} if attributes[:extras]
    super attributes
  end

  def free?
    price == 0
  end

  def attributes
    super.merge(has_extras: !extras.empty?)
  end
end
