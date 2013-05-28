class InvoiceReminderService
  def call(reminder)
    if space = reminder.space
      memberships = space.memberships.select{|membership| membership.user && membership.next_invoice_at}
      log "Sending reminders to up to #{memberships.size} members for #{space.name}."
      memberships.each do |membership|
        plan = current_plan membership
        if !plan.free? && membership.next_invoice_at == reminder.days_before.days.from_now.to_date
          log "Sending reminder to member #{membership.address.name}"
          ReminderMailer.invoice_reminder(reminder.space, membership, plan, reminder).deliver
        end
      end
    end
  end

  def self.send_reminders
    service = new
    log "Processing #{Reminder.count} reminders"
    Reminder.all.each do |reminder|
      Raven.capture do
        service.call(reminder)
      end
    end
  end

  private

  def log(message)
    self.class.log(message)
  end

  def self.log(message)
    logger.info message
  end

  def self.logger
    @logger ||=  if ENV['SYSLOG_HOST']
      RemoteSyslogLogger.new(ENV['SYSLOG_HOST'], ENV['SYSLOG_PORT'], program: "reminders")
    else
      Rails.logger
    end
  end

  def current_plan(membership)
    if membership.plan.canceled_to && membership.plan.canceled_to < membership.next_invoice_at
      membership.upcoming_plan
    else
      membership.plan
    end
  end
end
