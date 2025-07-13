class Product < ApplicationRecord
  belongs_to :sub_category
  has_one :inventory, dependent: :destroy
  has_many :product_reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_one_attached :image
  has_one :discount, dependent: :destroy
  has_and_belongs_to_many :fest_specials
  
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

  def sub_category_name
    sub_category.name if sub_category.present?
  end

  def discounted_price
    if discount.nil?
      0
    elsif discount.discount_type == 1
      discount.discount_value
    else
      self.price * (discount.discount_value / 100.0)
    end
  end

  def final_price
    sub_category.name if sub_category.present?
  end
end
