class BlogSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :heading, :description, :created_at, :updated_at, :image_url
end
