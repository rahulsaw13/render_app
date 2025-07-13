class Api::V1::SubCategoriesController < ApplicationController
  before_action :authenticate_user!
  include ActionController::MimeResponds
  
  def index
    @sub_categories = SubCategory.includes(:category).order(:name)
    if @sub_categories
      # Serialize using FastJsonapi
      serialized_data = SubCategorySerializer.new(@sub_categories).serializable_hash[:data]
      
      # Map the data to only include the fields you want, skipping 'type' and 'attributes'
      sub_categories_data = serialized_data.map do |sub_category|
        {
          id: sub_category[:id],
          name: sub_category[:attributes][:name],
          description: sub_category[:attributes][:description],
          image_url: sub_category[:attributes][:image_url],
          category_name: sub_category[:attributes][:category_name],
          status: sub_category[:attributes][:status]
        }
      end

      # Render the custom JSON format inside `data`
      render json: sub_categories_data
    else
      render json: { errors: "No subcategories found" }, status: :unprocessable_entity
    end
  end

  def filter
    # Start by including the category and ordering subcategories by name
    @sub_categories = SubCategory.includes(:category).order(created_at: :desc)
  
    @total = @sub_categories.count

    # Apply search filter if the 'search' parameter is present
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @sub_categories = @sub_categories.where("name ILIKE ? OR description ILIKE ? OR status::text ILIKE ?", search_term, search_term, search_term)
    end
  
    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed
  
    @sub_categories = @sub_categories.offset(skip).limit(limit)
  
    # Serialize using FastJsonapi
    if @sub_categories.any?
      serialized_data = SubCategorySerializer.new(@sub_categories).serializable_hash[:data]
  
      # Map the data to include the fields you want, skipping 'type' and 'attributes'
      sub_categories_data = serialized_data.map do |sub_category|
        {
          id: sub_category[:id],
          name: sub_category[:attributes][:name],
          description: sub_category[:attributes][:description],
          image_url: sub_category[:attributes][:image_url],
          category_name: sub_category[:attributes][:category_name],
          status: sub_category[:attributes][:status]
        }
      end
  
      # Render the custom JSON format inside `data`
      render json: {
        data: sub_categories_data,
        total: @total
      }
    else
      render json: { errors: "No subcategories found" }, status: :unprocessable_entity
    end
  end  

  def active_sub_categories_list
    @sub_categories = SubCategory.where(status: 1)
    if @sub_categories
      render json: @sub_categories
    else
      render json: { errors: "No subcategories found" }, status: :unprocessable_entity
    end
  end

  def create
    sub_category = SubCategory.new(sub_category_params)
    if sub_category.save
      render json: { data: sub_category, message: 'Sub category has been successfully created'}, status: :created
    else
      render json: { errors: sub_category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @sub_category = SubCategory.find(params[:id])
    if @sub_category
      render json: SubCategorySerializer.new(@sub_category).serializable_hash[:data][:attributes]
    else
      render json: { errors: @sub_category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    sub_category = SubCategory.find(params[:id])
    if sub_category.update(sub_category_params)
      render json: { data: sub_category, message: 'Category has been successfully updated'}
    else
      render json: { errors: sub_category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    sub_category = SubCategory.find_by(id: params[:id])
    if sub_category.destroy
      head :ok
    else
      render json: { errors: sub_category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sub_category_params
    params.permit(:name, :description, :status, :image, :category_id)
  end
end
