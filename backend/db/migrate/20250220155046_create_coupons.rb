class CreateCoupons < ActiveRecord::Migration[7.2]
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :discount_type
      t.decimal :discount_value
      t.datetime :valid_from
      t.datetime :valid_until

      t.timestamps
    end
  end
end
