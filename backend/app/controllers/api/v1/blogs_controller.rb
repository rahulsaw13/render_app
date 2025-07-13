class Api::V1::BlogsController < ApplicationController

  def index
    @blogs = Blog.order(created_at: :desc)
    if @blogs
      blogs_data = @blogs.map do |blog|
        BlogSerializer.new(blog).serializable_hash[:data][:attributes]
      end
      render json: blogs_data
    else
      render json: { errors: @categories.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def filter
    @blogs = Blog.order(created_at: :desc)
    @total = @blogs.count

    # Apply search filter if the 'search' parameter is present
    if params[:search].present?
      @blogs = @blogs.where("heading ILIKE ? OR description ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end

    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed

    @blogs = @blogs.offset(skip).limit(limit)

    if @blogs
      blogs_data = @blogs.map do |blog|
        BlogSerializer.new(blog).serializable_hash[:data][:attributes]
      end
      render json: {
        data: blogs_data,
        total: @total
      }
    else
      render json: { errors: @categories.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    blog = Blog.new(blog_params)
    if blog.save
      render json: { data: blog, message: 'Blog has been successfully created'}, status: :created
    else
      render json: { errors: blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @blog = Blog.find(params[:id])
    if @blog
      render json: BlogSerializer.new(@blog).serializable_hash[:data][:attributes]
    else
      render json: { errors: @blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update(blog_params)
      render json: { data: @blog, message: 'Blog has been successfully updated'}
    else
      render json: { errors: blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @blog = Blog.find_by(id: params[:id])
    if @blog.destroy
      head :ok
    else
      render json: { errors: @blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def blog_params
    params.permit(:heading, :description, :image)
  end
end
