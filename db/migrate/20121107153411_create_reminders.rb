class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :space_id, :subject, :access_token
      t.text :body
      t.integer :days_before
    end
  end
end
