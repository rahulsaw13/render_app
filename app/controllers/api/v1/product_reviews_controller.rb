class Api::V1::ProductReviewsController < ApplicationController
  before_action :authenticate_user!
  
  def filter
    @reviews = ProductReview.includes(:product, :user).order(created_at: :desc)
    @total = @reviews.count

    # Apply search filter if the 'search' parameter is present
    if params[:search].present?
      @reviews = @reviews.where("rating ILIKE ? OR review_text ILIKE ? OR products.name ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end

    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed

    @reviews = @reviews.offset(skip).limit(limit)
   
    if @reviews
      reviews_data = @reviews.map do |review|
        {
          id: review.id,
          rating: review.rating,
          review_text: review.review_text,
          created_at: review.created_at,
          updated_at: review.updated_at,
          email: review.email,
          is_verified: review.is_verified,
          name: review.name,
          image_url: review.image_url,
          product_data: {
            id: review.product.id,
            name: review.product.name + " " + review.product.weight,
            description: review.product.description,
            price: review.product.price
          },
          user_data: {
            id: review&.user&.id,
            name: review&.user&.name,
            email: review&.user&.email
          }
        }
      end
  
      render json: {
        data: reviews_data,
        total: @total
      }
    else
      render json: { errors: @categories.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    product_review = ProductReview.find_by(id: params[:id])
    if product_review.destroy
      head :ok
    else
      render json: { errors: product_review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def blog_params
    params.permit(:search, :limit, :skip)
  end
end
