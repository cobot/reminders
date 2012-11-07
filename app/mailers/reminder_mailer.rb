class ReminderMailer < ActionMailer::Base
  module MoneyFilter
    def money(input)
      sprintf('%.2f', input.to_f)
    end
  end

  def invoice_reminder(space, membership, reminder)
    mail to: membership.user.email, subject: reminder.subject do |format|
      format.text do
        context = Liquid::Context.new('plan' => LiquidModelDecorator.new(membership.plan),
          'membership' => LiquidModelDecorator.new(membership.attributes),
          'days' => reminder.days_before)
        context.add_filters MoneyFilter
        render text: Liquid::Template.parse(reminder.body).render(context)
      end
    end
  end
end
