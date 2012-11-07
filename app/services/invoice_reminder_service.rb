class InvoiceReminderService
  def call(reminder)
    reminder.space.memberships.each do |membership|
      if !membership.plan.free? &&
        membership.next_invoice_at == reminder.days_before.days.from_now.to_date &&
        membership.user
          ReminderMailer.invoice_reminder(reminder.space, membership, reminder).deliver
      end
    end
  end
end
