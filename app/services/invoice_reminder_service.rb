class InvoiceReminderService
  def call(reminder)
    space = Space.find(reminder.space_id, reminder.access_token)
    space.memberships.each do |membership|
      ReminderMailer.invoice_reminder(space, membership, reminder).deliver
    end
  end
end
