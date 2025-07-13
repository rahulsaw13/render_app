class UpdateUserOtpsAddEmailOtpAndPhoneOtp < ActiveRecord::Migration[7.2]
  def change
    add_column :user_otps, :email_otp, :integer
    add_column :user_otps, :phone_otp, :integer

    # Remove the existing otp_code column
    remove_column :user_otps, :otp_code, :integer
  end
end
