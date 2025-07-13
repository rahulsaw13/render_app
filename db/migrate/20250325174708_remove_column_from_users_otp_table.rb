class RemoveColumnFromUsersOtpTable < ActiveRecord::Migration[7.2]
  def change
    remove_column :user_otps, :is_used, :integer
  end
end
