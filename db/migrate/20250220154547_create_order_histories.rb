class CreateOrderHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :order_histories do |t|
      t.references :order, null: false, foreign_key: true
      t.string :status
      t.datetime :status_changed_at
      t.references :changed_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
