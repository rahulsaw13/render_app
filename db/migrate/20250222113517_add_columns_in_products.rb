class AddColumnsInProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :tax, :integer
    add_column :products, :final_price, :decimal, precision: 10, scale: 2
  end
end
