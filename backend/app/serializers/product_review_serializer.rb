class ProductReviewSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :product_id, :user_id, :rating, :review_text, :created_at, :updated_at, :email, :is_verified, :name, :image_url
end