class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
         
  belongs_to :role, optional: true
  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_one :user_otp, dependent: :destroy
  has_many :product_reviews, dependent: :destroy
  has_one_attached :image
  
  def image_validation
    if image.attached?
      if image.byte_size > 20.megabytes
        errors.add(:image, "should be less than 20 MB")
      end
      acceptable_types = ["image/jpeg", "image/png"]
      unless acceptable_types.include?(image.content_type)
        errors.add(:image, "must be a JPEG or PNG")
      end
    else
      errors.add(:image, "must be attached")
    end
  end

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

end
