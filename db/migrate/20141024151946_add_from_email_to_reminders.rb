class AddFromEmailToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :from_email, :string
  end
end
