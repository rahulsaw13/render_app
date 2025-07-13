class CreateBlogs < ActiveRecord::Migration[7.2]
  def change
    create_join_table :fest_specials, :products do |t|
      t.index :fest_special_id
      t.index :product_id
    end
  end
end
