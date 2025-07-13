class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  
  def filter
    # Start by filtering users based on the search parameter for email
    @users = User.where(role_id: 1)
    .where("name ILIKE ? OR email ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    .order(created_at: :desc)
    @total = @users.count

    skip = params.fetch(:skip, 0).to_i
    limit = params.fetch(:limit, 10).to_i
  
    @users = @users.offset(skip).limit(limit)
  
    # Render the users data
    if @users.any?
      render json: {
        data: @users,
        total: @total
      }
    else
      render json: { errors: "No users found" }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    if user
      user.user_otp&.destroy
      user.destroy
      head :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
      @user = User.find(params[:id])
      if @user
        render json: UserSerializer.new(@user).serializable_hash[:data][:attributes]
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: { data: user, message: 'User has been successfully updated'}
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def get_users_list
    @users = User.order(:name)
    if @users
      render json: @users
    else
      render json: { errors: @users.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :gender, :role_id, :image, :phone_number)
  end
end