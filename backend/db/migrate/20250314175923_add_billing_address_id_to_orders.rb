class AddBillingAddressIdToOrders < ActiveRecord::Migration[6.0]
  def change
    # Add billing_address_id as a reference column with a foreign key constraint
    add_reference :orders, :billing_address, foreign_key: { to_table: :addresses }
  end
end
