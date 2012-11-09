class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :cobot_id, :access_token
      t.text :admin_of
    end
  end
end
