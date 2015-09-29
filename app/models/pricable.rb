module Pricable
  def initialize(*args)
    super
    self.price = BigDecimal.new(price_in_cents.to_s) / 100.0
    self.price = price * (tax_rate / 100 + 1) if charge_taxes
  end
end