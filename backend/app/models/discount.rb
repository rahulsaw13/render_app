class Discount < ApplicationRecord
  belongs_to :product

  def product_name
    product.name + " " + product.weight if product.present?
  end
end
