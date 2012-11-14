module LiquidHelper
  module MoneyFilter
    def money(input)
      sprintf('%.2f', input.to_f)
    end
  end

  def render_liquid(membership, reminder)
    context = Liquid::Context.new('plan' => LiquidModelDecorator.new(membership.plan),
      'member' => LiquidModelDecorator.new(membership),
      'days' => reminder.days_before)
    context.add_filters MoneyFilter
    Liquid::Template.parse(reminder.body).render(context)
  end
end
