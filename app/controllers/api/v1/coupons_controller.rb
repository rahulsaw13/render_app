class Api::V1::CouponsController < ApplicationController
  before_action :authenticate_user!
  include ActionController::MimeResponds
  
  def index
    @coupons = Coupon.order(:created_at)
    if @coupons
      render json: @coupons
    else
      render json: { errors: @coupons.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def filter
    # Start by fetching all coupons and ordering by creation date
    @coupons = Coupon.order(created_at: :desc)
    @total = @coupons.count
  
    # Apply search filter if the 'search' parameter is present
    if params[:search].present?
      @coupons = @coupons.where("code ILIKE ?", "%#{params[:search]}%")
    end
  
    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed
  
    @coupons = @coupons.offset(skip).limit(limit)
  
    # Render the coupons data
    if @coupons.any?
      render json: {
        data: @coupons,
        total: @total
      }
    else
      render json: { errors: "No coupons found" }, status: :unprocessable_entity
    end
  end

  def create
    coupon = Coupon.new(coupon_params)
    if coupon.save
      render json: { data: coupon, message: 'Coupon has been successfully created'}, status: :created
    else
      render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @coupon = Coupon.find(params[:id])
    if @coupon
      render json: @coupon
    else
      render json: { errors: @coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    coupon = Coupon.find(params[:id])
    if coupon.update(coupon_params)
      render json: { data: coupon, message: 'Coupon has been successfully updated'}
    else
      render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    coupon = Coupon.find_by(id: params[:id])
    if coupon.destroy
      head :ok
    else
      render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def check_user_coupon
    coupon = Coupon.find_by(code: params[:code], user_id: params[:user_id])
    if coupon
      render json: { data: coupon, message: 'Coupon has been added successfully'}
    else
      render json: { errors: 'Coupon not valid' }, status: :unprocessable_entity
    end
  end

  private

  def coupon_params
    params.permit(:code, :discount_type, :discount_value, :valid_from, :valid_until, :user_id)
  end
end
