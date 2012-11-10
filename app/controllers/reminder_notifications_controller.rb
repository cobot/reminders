class ReminderNotificationsController < ApplicationController
  skip_before_filter :require_user
  before_filter :check_token

  def create
    Reminder.all.each do |reminder|
      service.call(reminder)
    end
    head :created
  end

  private

  def check_token
    if params[:token] != Reminders::Config.api_token
      head 403
    end
  end

  def service
    @service ||= InvoiceReminderService.new
  end
end
