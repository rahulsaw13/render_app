class AddUserIdToCoupons < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :user_id, :integer

    # Add foreign key constraint
    add_foreign_key :coupons, :users, column: :user_id
  end
end
