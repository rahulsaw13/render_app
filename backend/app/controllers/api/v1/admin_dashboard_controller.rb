class Api::V1::AdminDashboardController < ApplicationController
  before_action :authenticate_user!
  include ActionController::MimeResponds

  def counts
    @counts = {
      category_count: Category.count,
      sub_category_count: SubCategory.count,
      product_count: Product.count,
      customer_count: User.where(role_id: 2).count,
      order_count: Order.count,
      total_revenue: Order.sum(:total_price)
    }
    if @counts
      render json: @counts
    else
      render json: { errors: "No records found" }, status: :unprocessable_entity
    end

  end
end