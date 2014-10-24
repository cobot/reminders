class ReminderMailer < ActionMailer::Base
  include LiquidHelper

  def invoice_reminder(space, membership, reminder, paid_for_memberships)
    mail from: (reminder.from_email? && reminder.from_email) || space.email || 'support@cobot.me',
      bcc: reminder.bcc,
      to: membership.user.email,
      subject: reminder.subject do |format|
      format.text do
        render text: render_liquid(membership, reminder, paid_for_memberships)
      end
    end
  end
end
