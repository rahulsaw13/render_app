class Api::V1::ContactDetailsController < ApplicationController
  before_action :authenticate_user!
  include ActionController::MimeResponds

  def filter
    @contacts = ContactDetail.order(created_at: :desc)
    @total = @contacts.count

    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @contacts = @contacts.where(
        "name ILIKE :search OR email ILIKE :search OR phone_number ILIKE :search OR message ILIKE :search",
        search: search_term
      )
    end    

    # Apply skip (offset) and limit (pagination)
    skip = params[:skip].to_i || 0    # Default to 0 if no skip parameter is passed
    limit = params[:limit].to_i || 10  # Default to 10 if no limit parameter is passed

    # Apply the pagination to the filtered contacts
    @contacts = @contacts.offset(skip).limit(limit)

    # Check if contacts are found and return serialized data
    if @contacts.any?
      render json: {
        data: @contacts,
        total: @total  # Return the total count of records that match the search filter
      }
    else
      render json: { errors: ['No contacts found'] }, status: :not_found
    end

  end

  def destroy
    contact_detail = ContactDetail.find_by(id: params[:id])
    if contact_detail.destroy
      head :ok
    else
      render json: { errors: contact_detail.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_contact_form
    @contact_form = ContactDetail.find(params[:id])
  end

  def contact_form_params
    params.permit(:name, :email, :phone_number, :message, :remember_me)
  end
end
