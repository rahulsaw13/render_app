class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :products, dependent: :destroy
  has_one_attached :image

  # validates :name, presence: true, length: { maximum: 20 }
  # validates :description, presence: true
  # validate :image_validation

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

  def category_name
    category.name if category.present?
  end

end
