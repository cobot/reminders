class InvoiceReminderService
  def call(reminder)
    if space = reminder.space
      memberships = space.memberships.select(&:next_invoice_at)
      teams = space.teams
      log "Sending reminders to up to #{memberships.size} members for #{space.name}."
      memberships.select(&:user).each do |membership|
        if should_send_reminder?(membership, reminder, teams)
          log "Sending reminder to member #{membership.address.name}"
          begin
            ReminderMailer.invoice_reminder(reminder.space, membership, reminder,
              paid_for_memberships(membership, teams, memberships)).deliver
          rescue SimplePostmark::APIError => e
            logger.warn "Got postmark error #{e.message} for reminder #{reminder.id}."
          end
        end
      end
    end
  end

  def self.send_reminders
    log "Processing #{Reminder.count} reminders"
    Reminder.all.each do |reminder|
      begin
        new.call(reminder)
      rescue RestClient::PaymentRequired
        log "Space for reminder #{reminder.id} suspended. Ignoring."
      rescue => e
        if Rails.env.production?
          Raven.capture_exception e, extra: {reminder_id: reminder.id}
        else
          raise e
        end
      end
    end
  end

  private

  def paid_for_memberships(paying_membership, all_teams, all_memberships)
    team = all_teams.find do |t|
      t[:memberships].find do |m|
        m[:role] == 'paying' &&
          m[:membership][:id] == paying_membership.id
      end
    end
    if team
      team[:memberships].select {|m| m[:role] == 'paid' }.map {|m|
        all_memberships.find {|membership| membership.id == m[:membership][:id] }
      }
    end
  end

  def should_send_reminder?(membership, reminder, teams)
    (!membership.current_plan.free? || paying_for_other_members?(teams, membership)) &&
      membership.next_invoice_at == reminder.days_before.days.from_now.to_date &&
      !paid_for_by_other_member?(teams, membership)
  end

  def paid_for_by_other_member?(teams, membership)
    teams.map{|team| team[:memberships] }.flatten.find {|m|
      m[:role] == 'paid' &&
      m[:membership][:id] == membership.id
    }
  end

  def paying_for_other_members?(teams, membership)
    teams.map {|team| team[:memberships] }.flatten.find {|m|
      m[:role] == 'paying' &&
      m[:membership][:id] == membership.id
    }
  end

  def log(message)
    self.class.log(message)
  end

  def logger
    self.class.logger
  end

  def self.log(message)
    logger.info message
  end

  def self.logger
    Rails.logger
  end
end
