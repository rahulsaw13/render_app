class RemoveStatusFromDiscounts < ActiveRecord::Migration[7.2]
  def change
    remove_column :discounts, :status, :integer
  end
end
