desc 'sends the reminder emails'
task :send_emails do
  InvoiceReminderService.send_reminders
end
