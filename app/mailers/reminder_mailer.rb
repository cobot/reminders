class ReminderMailer < ActionMailer::Base
  include LiquidHelper

  def invoice_reminder(space, membership, plan, reminder)
    mail from: 'support@cobot.me', to: membership.user.email, subject: reminder.subject do |format|
      format.text do
        render text: render_liquid(membership, plan, reminder)
      end
    end
  end
end
