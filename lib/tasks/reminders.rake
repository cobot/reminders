desc 'sends the reminder emails'
task :send_emails do
  Raven.capture do
    InvoiceReminderService.send_reminders
  end
end
