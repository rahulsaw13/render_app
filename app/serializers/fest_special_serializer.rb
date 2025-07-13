class FestSpecialSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :status, :name, :products, :created_at, :updated_at, :image_url

  attribute :products do |object|
    object.product_names
  end

   # Only for show action or when needed
  attribute :product_ids, if: Proc.new { |record, params|
   params && params[:include_product_ids]
   } do |object|
   object.products.pluck(:id)
  end
end
