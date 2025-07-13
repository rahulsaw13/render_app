class Order < ApplicationRecord
  belongs_to :user
  # has_many :order_histories, dependent: :destroy
  # has_one :payment_transactions, dependent: :destroy
  belongs_to :billing_address, class_name: 'Address', foreign_key: 'billing_address_id'
  belongs_to :shipping_address, class_name: 'Address', foreign_key: 'shipping_address_id', optional: true

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
end