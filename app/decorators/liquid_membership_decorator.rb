class LiquidMembershipDecorator < LiquidModelDecorator
  def to_liquid
    super.merge('plan' => LiquidModelDecorator.new(@model.current_plan).to_liquid)
  end
end
