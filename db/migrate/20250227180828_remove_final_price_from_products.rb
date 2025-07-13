class RemoveFinalPriceFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :final_price, :decimal
  end
end
