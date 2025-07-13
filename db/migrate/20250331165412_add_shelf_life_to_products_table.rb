class AddShelfLifeToProductsTable < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :shelf_life, :integer
  end
end
