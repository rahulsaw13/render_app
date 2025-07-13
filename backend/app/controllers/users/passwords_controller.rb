# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  def new
    super
  end

  def create
    self.resource = resource_class.find_by(email: resource_params[:email])
  
    if resource
      token = resource.send(:set_reset_password_token)
      UserMailer.reset_password_email(resource, token).deliver_now
      render json: { message: 'Reset password link has been sent to your email.' }, status: :ok
    else
      render json: { error: 'Email address not found.' }, status: :not_found
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.save
      UserMailer.password_changed(resource).deliver_now
      render json: { message: 'Password has been successfully updated.' }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  protected

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    super(resource_name)
  end
end
