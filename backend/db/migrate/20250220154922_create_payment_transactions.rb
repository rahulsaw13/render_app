class CreatePaymentTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_transactions do |t|
      t.references :order, null: false, foreign_key: true
      t.string :payment_method
      t.decimal :amount
      t.string :transaction_status

      t.timestamps
    end
  end
end
