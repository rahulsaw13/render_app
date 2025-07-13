class Api::V1::FestSpecialsController < ApplicationController
  before_action :authenticate_user!
  include ActionController::MimeResponds

  def filter

    # Start by ordering festivals
    @festivals = FestSpecial.includes(:products).order(created_at: :desc)

    @total = @festivals.count

    # Apply search filter if a search term is provided (search in name, or status)
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @festivals = @festivals.where("name ILIKE ?", search_term)
    end
  
    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed
  
    # Apply the pagination to the filtered categories
    @festivals = @festivals.offset(skip).limit(limit)
    
    # Check if categories are found and return serialized data
    if @festivals.any?
      festivals_data = @festivals.map do |fest|
        FestSpecialSerializer.new(fest).serializable_hash[:data][:attributes]
      end

      render json: {
        data: festivals_data,
        total: @total  # Return the total count of records that match the search filter
      }
    else
      render json: { errors: ['No festival special found'] }, status: :not_found
    end
  end  

  def create
    @fest_special = FestSpecial.new(fest_special_params)
  
    if @fest_special.save
      product_ids = params[:products]
      product_ids = product_ids.split(',') if product_ids.is_a?(String)
      @fest_special.product_ids = product_ids
  
      render json: serialize_fest_special(@fest_special), status: :created
    else
      render json: { errors: @fest_special.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @fest_special = FestSpecial.includes(:products).find(params[:id])
    if @fest_special
      render json: FestSpecialSerializer.new(@fest_special, { params: { include_product_ids: true } }).serializable_hash[:data][:attributes]
    else
      render json: { errors: @fest_special.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    fest_special = FestSpecial.find(params[:id])
  
    if fest_special.update(fest_special_params)
      if params[:products].present?
        # Handle comma-separated string or array of product ids
        product_ids = params[:products].is_a?(String) ? params[:products].split(',').map(&:strip) : params[:products]
        fest_special.product_ids = product_ids
      end
  
      render json: { data: fest_special, message: 'Festival Special has been successfully updated' }
    else
      render json: { errors: fest_special.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_status
    fest_special = FestSpecial.find(params[:id])
  
    new_status = fest_special.status == 1 ? 0 : 1

    if fest_special.update(status: new_status)
      render json: {
        data: fest_special,
        message: 'Festival Special status has been successfully updated'
      }
    else
      render json: {
        errors: fest_special.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    fest_special = FestSpecial.find(params[:id])
    
    # Destroy the fest_special and its associated products if necessary
    if fest_special.destroy
      render json: { message: 'Festival special has been successfully deleted' }, status: :ok
    else
      render json: { errors: fest_special.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'FestSpecial not found' }, status: :not_found
  end

  def serialize_fest_special(fest)
    {
      name: fest.name,
      products: fest.products.pluck(:name).join(', ')
    }
  end

  private

  def fest_special_params
    params.permit(:name, :status, :image)
  end
end
