class CreateFestSpecials < ActiveRecord::Migration[7.2]
  def change
    create_table :fest_specials do |t|
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
