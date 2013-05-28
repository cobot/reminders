desc 'sends the reminder emails'
task send_emails: :environment do
  Raven.capture do
    InvoiceReminderService.send_reminders
  end
end
