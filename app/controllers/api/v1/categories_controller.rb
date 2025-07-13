class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_user!
  include ActionController::MimeResponds
  
  def index
    @categories = Category.order(:name)
    if @categories
      categories_data = @categories.map do |category|
        CategorySerializer.new(category).serializable_hash[:data][:attributes]
      end
      render json: categories_data
    else
      render json: { errors: @categories.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def filter
    # Start by ordering categories
    @categories = Category.order(created_at: :desc)

    @total = @categories.count

    # Apply search filter if a search term is provided (search in name, description, or status)
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @categories = @categories.where("name ILIKE ? OR description ILIKE ? OR status::text ILIKE ?", search_term, search_term, search_term)
    end
  
    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed
  
    # Apply the pagination to the filtered categories
    @categories = @categories.offset(skip).limit(limit)
  
    # Check if categories are found and return serialized data
    if @categories.any?
      categories_data = @categories.map do |category|
        CategorySerializer.new(category).serializable_hash[:data][:attributes]
      end
      render json: {
        data: categories_data,
        total: @total  # Return the total count of records that match the search filter
      }
    else
      render json: { errors: ['No categories found'] }, status: :not_found
    end
  end  

  def active_categories_list
    @categories = Category.order(:name).where(status: 1)
    if @categories
      render json: @categories
    else
      render json: { errors: @categories.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: { data: category, message: 'Category has been successfully created'}, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @category = Category.find(params[:id])
    if @category
      render json: CategorySerializer.new(@category).serializable_hash[:data][:attributes]
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    category = Category.find(params[:id])
    if category.update(category_params)
      render json: { data: category, message: 'Category has been successfully updated'}
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    category = Category.find_by(id: params[:id])
    if category.destroy
      head :ok
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.permit(:name, :description, :status, :image)
  end
end
