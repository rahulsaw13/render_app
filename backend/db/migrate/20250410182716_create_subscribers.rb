class CreateSubscribers < ActiveRecord::Migration[7.2]
  def change
    create_table :subscribers do |t|
      t.string :email

      t.timestamps
    end
    add_index :subscribers, :email, unique: true
  end
end
