class RemoveFestSpecialToProductsTable < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :fest_special_id, :bigint
  end
end
