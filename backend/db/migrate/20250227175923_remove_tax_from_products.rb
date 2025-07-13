class RemoveTaxFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :tax, :integer
  end
end
