class AddWeightToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :weight, :string
  end
end
