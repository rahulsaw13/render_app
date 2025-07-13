class CreateInventories < ActiveRecord::Migration[7.2]
  def change
    create_table :inventories do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :stock_quantity

      t.timestamps
    end
  end
end
