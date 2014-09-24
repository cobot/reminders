class InvoiceReminderService
  def call(reminder)
    if space = reminder.space
      memberships = space.memberships.select{|membership| membership.next_invoice_at }
      teams = space.teams
      log "Sending reminders to up to #{memberships.size} members for #{space.name}."
      memberships.select{|membership| membership.user }.each do |membership|
        if should_send_reminder?(membership, reminder, teams)
          log "Sending reminder to member #{membership.address.name}"
          begin
            ReminderMailer.invoice_reminder(reminder.space, membership,
              reminder,
              paid_for_memberships(membership, teams, memberships)).deliver
          rescue SimplePostmark::APIError
            # ignore, probably email blocked by postmark because of bounce
          end
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

  def paid_for_memberships(paying_membership, all_teams, all_memberships)
    team = all_teams.find{|t|
      t[:memberships].find{|m| m[:role] == 'paying' &&
        m[:membership][:id] == paying_membership.id}
    }
    if team
      team[:memberships].select{|m| m[:role] == 'paid'}.map{|m|
        all_memberships.find{|membership| membership.id == m[:membership][:id] } }
    end
  end

  def should_send_reminder?(membership, reminder, teams)
    (!membership.current_plan.free? || is_paying_for_other_members?(teams, membership)) &&
      membership.next_invoice_at == reminder.days_before.days.from_now.to_date &&
      !is_paid_for_by_other_member?(teams, membership)
  end

  def is_paid_for_by_other_member?(teams, membership)
    teams.map{|team| team[:memberships] }.flatten.find{|m|
      m[:role] == 'paid' &&
      m[:membership][:id] == membership.id
    }
  end

  def is_paying_for_other_members?(teams, membership)
    teams.map{|team| team[:memberships] }.flatten.find{|m|
      m[:role] == 'paying' &&
      m[:membership][:id] == membership.id
    }
  end

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
end
