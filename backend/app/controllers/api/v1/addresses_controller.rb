class Api::V1::AddressesController < ApplicationController
  # before_action :authenticate_user!
  
  def get_user_address_list
    address_list = Address.where(user_id: params[:id])
    if address_list
      render json: { data: address_list }
    else
      render json: { errors: address_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    address = Address.new(address_params)

    if address.save
      render json: { data: address, message: 'Address has been successfully created' }, status: :created
    else
      render json: { errors: address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @addresess = Address.all()
    if @addresess
      render json: @addresess
    else
      render json: { errors: @addresess.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def address_params
    params.permit(:flat_no, :landmark, :city, :state, :zip_code, :country, :user_id)
  end
end
