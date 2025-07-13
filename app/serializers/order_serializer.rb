class OrderSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :handling_fee, :total_price, :tax_price, :order_status, :payment_status, :payment_mode, :shipping_address, :billing_address,  :created_at, :updated_at

  attribute :billing_address do |data|
    data.billing_address
  end

  attribute :shipping_address do |data|
    data.shipping_address
  end
end
