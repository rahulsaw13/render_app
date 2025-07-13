class UserOtp < ApplicationRecord
  belongs_to :user

  def expired?
    expires_at < Time.current
  end
end
