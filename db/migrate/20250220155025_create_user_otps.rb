class CreateUserOtps < ActiveRecord::Migration[7.2]
  def change
    create_table :user_otps do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :otp_code
      t.datetime :expires_at
      t.integer :is_used

      t.timestamps
    end
  end
end
