class SubCategorySerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :description, :category_id, :status, :created_at, :updated_at, :image_url

  # Declare the virtual attribute category_name here
  attribute :category_name do |sub_category|
    sub_category.category_name
  end
end