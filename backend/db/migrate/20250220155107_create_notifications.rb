class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.string :notification_text
      t.integer :is_show

      t.timestamps
    end
  end
end
