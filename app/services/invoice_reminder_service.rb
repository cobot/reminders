class InvoiceReminderService
  def call(reminder)
    if space = reminder.space
      space.memberships.select{|membership| membership.user && membership.next_invoice_at}.each do |membership|
        plan = current_plan membership
        if !plan.free? && membership.next_invoice_at == reminder.days_before.days.from_now.to_date
          ReminderMailer.invoice_reminder(reminder.space, membership, plan, reminder).deliver
        end
      end
    end
  end

  def self.send_reminders
    service = new
    Reminder.all.each do |reminder|
      Raven.capture do
        service.call(reminder)
      end
    end
  end

  private

  def current_plan(membership)
    if membership.plan.canceled_to && membership.plan.canceled_to < membership.next_invoice_at
      membership.upcoming_plan
    else
      membership.plan
    end
  end
end
