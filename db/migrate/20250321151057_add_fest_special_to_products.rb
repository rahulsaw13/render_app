class AddFestSpecialToProducts < ActiveRecord::Migration[7.2]
  def change
    add_reference :products, :fest_special, null: false, foreign_key: true
  end
end
