class AddRolesTable < ActiveRecord::Migration[7.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
  end
end
