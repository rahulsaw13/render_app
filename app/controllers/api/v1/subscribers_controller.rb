class Api::V1::SubscribersController < ApplicationController
  before_action :authenticate_user!
  
  def filter
    @subscribers = Subscriber.order(created_at: :desc)
    @total = @subscribers.count

    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @subscribers = @subscribers.where("email ILIKE ?", search_term)
    end

    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed

    # Apply the pagination to the filtered categories
    @subscribers = @subscribers.offset(skip).limit(limit)

    # Check if categories are found and return serialized data
    if @subscribers.any?
      render json: {
        data: @subscribers,
        total: @total  # Return the total count of records that match the search filter
      }
    else
      render json: { errors: ['No categories found'] }, status: :not_found
    end

  end

end
