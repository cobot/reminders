class ReminderMailer < ActionMailer::Base
  include LiquidHelper

  def invoice_reminder(space, membership, reminder)
    mail to: membership.user.email, subject: reminder.subject do |format|
      format.text do
        render text: render_liquid(membership, reminder)
      end
    end
  end
end
