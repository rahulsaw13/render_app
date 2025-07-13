class CreateContactDetails < ActiveRecord::Migration[7.2]
  def change
    create_table :contact_details do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.text :message
      t.boolean :remember_me

      t.timestamps
    end
  end
end
