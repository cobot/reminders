class LiquidModelDecorator
  def initialize(model)
    @model = model
  end

  def to_liquid
    @model.attributes.stringify_keys.reduce({}) do |hash, pair|
      name, value = pair
      if value.respond_to?(:attributes)
        hash[name] = value.attributes.stringify_keys
      else
        hash[name] = value
      end
      hash
    end
  end
end
