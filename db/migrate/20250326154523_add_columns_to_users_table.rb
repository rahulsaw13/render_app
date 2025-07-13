class AddColumnsToUsersTable < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :is_email_verified, :integer
    add_column :users, :is_phone_verified, :integer
  end
end
