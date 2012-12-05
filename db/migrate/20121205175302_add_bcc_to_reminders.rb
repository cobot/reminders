class AddBccToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :bcc, :string
  end
end
