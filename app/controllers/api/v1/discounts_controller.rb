class Api::V1::DiscountsController < ApplicationController
  before_action :authenticate_user!
  include ActionController::MimeResponds
  
  def index
    @discounts = Discount.order(created_at: :desc)
    @total = @discounts.count

    if @discounts
      serialized_data = DiscountSerializer.new(@discounts).serializable_hash[:data]
      
      # Map the data to only include the fields you want, skipping 'type' and 'attributes'
      discount_data = serialized_data.map do |data|
        {
          id: data[:id],
          discount_type: data[:attributes][:discount_type],
          product_name: data[:attributes][:product_name],
          discount_value: data[:attributes][:discount_value],
          start_date: data[:attributes][:start_date],
          end_date: data[:attributes][:end_date]
        }
      end
      
      render json: {
        data: discount_data,
        total: @total
      }
    else
      render json: { errors: @discounts.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def filter
    # Start by fetching all discounts and ordering by creation date
    @discounts = Discount.order(created_at: :desc)
    @total = @discounts.count

    if params[:search].present?
      @discounts = @discounts.joins(:product).where("products.name ILIKE ?", "%#{params[:search]}%")
    end
    
    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed
  
    @discounts = @discounts.offset(skip).limit(limit)
  
    # Serialize using FastJsonapi
    if @discounts.any?
      serialized_data = DiscountSerializer.new(@discounts).serializable_hash[:data]
  
      # Map the data to only include the fields you want, skipping 'type' and 'attributes'
      discount_data = serialized_data.map do |data|
        {
          id: data[:id],
          discount_type: data[:attributes][:discount_type],
          product_name: data[:attributes][:product_name],
          discount_value: data[:attributes][:discount_value],
          start_date: data[:attributes][:start_date],
          end_date: data[:attributes][:end_date]
        }
      end
      
      render json: {
        data: discount_data,
        total: @total
      }
    else
      render json: { errors: "No discounts found" }, status: :unprocessable_entity
    end
  end  

  def discount_product_list
    @products = Product.where(status: 1).where.not(id: Discount.select(:product_id)).order(:name)
    if @products
      serialized_data = ProductSerializer.new(@products).serializable_hash[:data]

      # Map the data to only include the fields you want, skipping 'type' and 'attributes'
      products_data = serialized_data.map do |product|
        {
          id: product[:id],
          name: product[:attributes][:name] + " " + product[:attributes][:weight]
        }
      end

      render json: products_data
    else
      render json: { errors: @products.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    discount = Discount.new(discount_params)
    if discount.save
      render json: { data: discount, message: 'Discount has been successfully created'}, status: :created
    else
      render json: { errors: discount.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @discount = Discount.find(params[:id])
    if @discount
      render json: @discount
    else
      render json: { errors: @discount.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    discount = Discount.find(params[:id])
    if discount.update(discount_params)
      render json: { data: discount, message: 'Discount has been successfully updated'}
    else
      render json: { errors: discount.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    discount = Discount.find_by(id: params[:id])
    if discount.destroy
      head :ok
    else
      render json: { errors: discount.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def discount_params
    params.permit(:product_id, :discount_type, :discount_value, :start_date, :end_date, :status)
  end
end
