class ProductSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :description, :status, :shelf_life, :price, :sub_category_id, :weight, :discounted_price, :created_at, :updated_at, :image_url

  # Declare the virtual attribute category_name here
  attribute :sub_category_name do |data|
    data.sub_category_name
  end

  attribute :discounted_price do |data|
    data.discounted_price
  end

  attribute :final_price do |data|
    data.final_price
  end
end