class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price
      t.string :payment_status
      t.references :shipping_address, foreign_key: { to_table: :addresses }
      t.string :billing_address
      t.string :order_status

      t.timestamps
    end
  end
end
