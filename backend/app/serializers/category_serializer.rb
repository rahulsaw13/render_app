class CategorySerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :description, :status, :created_at, :updated_at, :image_url
end
