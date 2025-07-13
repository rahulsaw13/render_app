class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :role_id, :email, :is_phone_verified, :phone_number, :gender, :created_at, :updated_at, :image_url
end