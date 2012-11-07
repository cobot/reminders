class LiquidModelDecorator
  def initialize(model)
    @model = model
  end

  def to_liquid
    @model.attributes.stringify_keys
  end
end
