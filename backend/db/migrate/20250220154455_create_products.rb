class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :status
      t.decimal :price
      t.references :sub_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
