class ChangeTypeFestSpecialToProducts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :products, :fest_special_id, true
  end
end
