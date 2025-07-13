class InventorySerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :product_id, :stock_quantity, :product_name, :created_at, :updated_at

  attribute :product_name do |data|
    data.product_name
  end
end
