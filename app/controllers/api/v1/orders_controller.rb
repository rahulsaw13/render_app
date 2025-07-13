# app/controllers/api/v1/orders_controller.rb
class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user!
  include ActionController::MimeResponds

  def index
    # Start by including necessary associations and ordering by creation date
    @orders = Order.includes(:shipping_address, :billing_address, :user).order(created_at: :desc)
  
    # Apply search filter if the 'search' parameter is present
    if params[:search].present?
      @orders = @orders.where("order_status ILIKE ? OR payment_status ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end
  
    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed
  
    @orders = @orders.offset(skip).limit(limit)
  
    # Serialize using FastJsonapi
    if @orders.any?
      serialized_data = OrderSerializer.new(@orders).serializable_hash[:data]
  
      # Map the data to only include the fields you want, skipping 'type' and 'attributes'
      @orders_data = serialized_data.map do |order|
        {
          id: order[:id],
          created_at: order[:attributes][:created_at],
          tax_price: order[:attributes][:tax_price],
          handling_fee: order[:attributes][:handling_fee],
          total_price: order[:attributes][:total_price],
          order_status: order[:attributes][:order_status],
          payment_status: order[:attributes][:payment_status],
          payment_mode: order[:attributes][:payment_mode],
          billing_address: [order[:attributes][:billing_address]['flat_no'], order[:attributes][:billing_address]['landmark'], order[:attributes][:billing_address]['landmark']].compact.join(' '),
          shipping_address: [order[:attributes][:shipping_address]['city'], order[:attributes][:shipping_address]['landmark'], order[:attributes][:shipping_address]['city']].compact.join(' '),
          user: order[:attributes][:user]
        }
      end
  
      render json: @orders_data
    else
      render json: { errors: "No orders found" }, status: :unprocessable_entity
    end
  end  

  def filter
    @orders = Order.includes(:shipping_address, :billing_address, :user).order(created_at: :desc)
    @total = @orders.count
  
    if params[:search].present?
      @orders = @orders.where("order_status ILIKE ? OR payment_status ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end
  
    skip = params[:skip].to_i
    limit = params[:limit].to_i
    skip = 0 if skip < 0
    limit = 10 if limit <= 0
  
    @orders = @orders.offset(skip).limit(limit)
  
    if @orders.any?
      serialized_data = OrderSerializer.new(@orders).serializable_hash[:data]
  
      @orders_data = serialized_data.map do |order|
        billing_address = order[:attributes][:billing_address]
        shipping_address = order[:attributes][:shipping_address]
  
        {
          id: order[:id],
          created_at: order[:attributes][:created_at],
          tax_price: order[:attributes][:tax_price],
          handling_fee: order[:attributes][:handling_fee],
          total_price: order[:attributes][:total_price],
          order_status: order[:attributes][:order_status],
          payment_status: order[:attributes][:payment_status],
          payment_mode: order[:attributes][:payment_mode],
          billing_address: billing_address.present? ? [
            billing_address['flat_no'],
            billing_address['landmark'],
            billing_address['city']
          ].compact.join(' ') : "No Billing Address",
          shipping_address: shipping_address.present? ? [
            shipping_address['flat_no'],
            shipping_address['landmark'],
            shipping_address['city']
          ].compact.join(' ') : "No Shipping Address",
          user: order[:attributes][:user]
        }
      end
  
      render json: { data: @orders_data, total: @total }
    else
      render json: { errors: "No orders found" }, status: :unprocessable_entity
    end
  end

  def show
    order = Order.includes(:user, :billing_address, :shipping_address, order_items: [:product]).find_by(id: params[:id])

    if order.present?
      order_data = {
        id: order.id,
        created_at: order.created_at,
        tax_price: order.tax_price,
        handling_fee: order.handling_fee,
        total_price: order.total_price,
        order_status: order.order_status,
        payment_status: order.payment_status,
        payment_mode: order.payment_mode,
        user: {
          id: order.user.id,
          name: order.user.name,
          email: order.user.email
        },
        billing_address: order.billing_address.present? ? [
          order.billing_address.flat_no,
          order.billing_address.landmark,
          order.billing_address.city
        ].compact.join(' ') : "No Billing Address",
        shipping_address: order.shipping_address.present? ? [
          order.shipping_address.flat_no,
          order.shipping_address.landmark,
          order.shipping_address.city
        ].compact.join(' ') : "No Shipping Address",
        products: order.order_items.map do |item|
          {
            product_id: item.product.id,
            name: item.product.name,
            quantity: item.quantity,
            price: item.price
          }
        end
      }

      render json: { data: order_data }
    else
      render json: { error: "Order not found" }, status: :not_found
    end
  end

  def create
    begin
      result = Api::V1::OrderService.create_order(order_params)
  
      if result.is_a?(Order)
        shipping_address = Address.find(result['shipping_address_id'])
        render json: {
          data: result.as_json.merge(shipping_address: shipping_address),
          message: 'Order has been successfully created'
        }, status: :created
      else
        render json: { errors: 'Order creation failed' }, status: :unprocessable_entity
      end
    rescue => e
      # This captures any error raised inside the service and returns it
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @order = Order.find_by(id: params[:id])
    if @order.destroy
      head :ok
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_payment_status
    begin
      order = Api::V1::OrderService.accept_payment!(params[:order_id])
      render json: {
        data: order,
        message: "Payment accepted and inventory updated."
      }, status: :ok
    rescue => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    # Strong parameters for order creation (as shown before)
    params.permit(
      :user_id, 
      :coupon, 
      :tax_price, 
      :handling_fee, 
      :billing_address_id, 
      :payment_status, 
      :order_status, 
      :payment_mode,
      :shipping_address_id, 
      :search, 
      :limit, 
      :skip,
      :total_price,
      products: [:product_id, :qty], 
      shipping_address: [:flat_no, :landmark, :city, :state, :zip_code, :country],
      order: [:user_id, :total_price, :payment_status, :order_status, :tax_price, :handling_fee, :billing_address_id, :payment_mode] # Permitting nested order attributes
    )
  end
end
