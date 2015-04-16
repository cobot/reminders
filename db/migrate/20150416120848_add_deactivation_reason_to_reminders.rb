class AddDeactivationReasonToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :deactivation_reason, :string
  end
end
