class DiscountSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :discount_type, :discount_value, :start_date, :end_date, :product_name

  # Declare the virtual attribute product name here
  attribute :product_name do |product|
    product.product_name
  end
end