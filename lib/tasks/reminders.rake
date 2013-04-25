desc 'sends the reminder emails'
task send_emails: :environment do
  InvoiceReminderService.send_reminders
end
