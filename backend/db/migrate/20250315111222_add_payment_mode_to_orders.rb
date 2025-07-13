class AddPaymentModeToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :payment_mode, :string
  end
end
