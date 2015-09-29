module LiquidHelper
  module MoneyFilter
    def money(input)
      sprintf('%.2f', input.to_f.round(2))
    end
  end

  def render_liquid(membership, reminder, paid_for_memberships = nil)
    context = Liquid::Context.new(
      'plan' => LiquidModelDecorator.new(membership.current_plan),
      'member' => LiquidModelDecorator.new(membership),
      'paid_for_members' => paid_for_memberships && paid_for_memberships.map{|m|
        LiquidMembershipDecorator.new(m) },
      'days' => reminder.days_before)
    context.add_filters MoneyFilter
    Liquid::Template.parse(reminder.body).render(context)
  end
end
