class Api::V1::InventoriesController < ApplicationController
  before_action :authenticate_user!
  include ActionController::MimeResponds
  
  def index
    @inventories = Inventory.all()
    if @inventories
      serialized_data = InventorySerializer.new(@inventories).serializable_hash[:data]
      
      # Map the data to only include the fields you want, skipping 'type' and 'attributes'
      inventory_data = serialized_data.map do |data|
        {
          id: data[:id],
          name: data[:attributes][:name],
          product_name: data[:attributes][:product_name],
          stock_quantity: data[:attributes][:stock_quantity]
        }
      end
      
      render json: inventory_data
    else
      render json: { errors: @inventories.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def filter
    # Start by fetching all inventories
    @inventories = Inventory.order(created_at: :desc)
    @total = @inventories.count
  
    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed
  
    if params[:search].present?
      @inventories = @inventories.joins(:product).where("products.name ILIKE ?", "%#{params[:search]}%")
    end

    @inventories = @inventories.offset(skip).limit(limit)
  
    # Serialize using FastJsonapi
    if @inventories.any?
      serialized_data = InventorySerializer.new(@inventories).serializable_hash[:data]
  
      # Map the data to only include the fields you want, skipping 'type' and 'attributes'
      inventory_data = serialized_data.map do |data|
        {
          id: data[:id],
          name: data[:attributes][:name],
          product_name: data[:attributes][:product_name],
          stock_quantity: data[:attributes][:stock_quantity]
        }
      end

      render json: {
        data: inventory_data,
        total: @total
      }
    else
      render json: { errors: "No inventories found" }, status: :unprocessable_entity
    end
  end  

  def inventory_product_list
    @products = Product.where(status: 1).where.not(id: Inventory.select(:product_id)).order(:name)
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
    inventory = Inventory.new(inventory_params)
    if inventory.save
      render json: { data: inventory, message: 'Inventory has been successfully created'}, status: :created
    else
      render json: { errors: inventory.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @inventory = Inventory.find(params[:id])
    if @inventory
      render json: @inventory
    else
      render json: { errors: @inventory.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    inventory = Inventory.find(params[:id])
    if inventory.update(inventory_params)
      render json: { data: inventory, message: 'Inventory has been successfully updated'}
    else
      render json: { errors: inventory.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    inventory = Inventory.find_by(id: params[:id])
    if inventory.destroy
      head :ok
    else
      render json: { errors: inventory.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def inventory_params
    params.permit(:product_id, :stock_quantity)
  end
end
