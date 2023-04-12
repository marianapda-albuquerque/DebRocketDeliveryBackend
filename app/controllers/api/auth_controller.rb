# frozen_string_literal: true

class Api::AuthController < ApplicationController
  def index
    transaction_succeeded = false
    
    ActiveRecord::Base.transaction do
      user = User.where(email: request.params["email"] || request.params["user"]["email"]).first

      if user != nil
        if user.valid_password?(request.params["password"] || request.params["user"]["password"])
          sign_in(:user, user)
          transaction_succeeded = true
        end
      end
    end

    if transaction_succeeded
      flash[:notice] = "You are signed in!"
      render json: {success: true}, status: 200
    else
      flash[:notice] = "Invalid email or password!"
      render json: {success: false}, status: 401
    end
  end
  
  def new
    render
  end

  # def create
  #   super
  # end

  # def destroy
  #   super
  # end

  # protected

  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
