# frozen_string_literal: true
class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  private

  def respond_with(resource, _opts = {})
    @user = User.find(resource[:id])
    if @user
      render json: {
        message: 'Logged in sucessfully.',
        data: UserSerializer.new(@user).serializable_hash[:data][:attributes]
      }, status: :ok
    end
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: "logged out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end