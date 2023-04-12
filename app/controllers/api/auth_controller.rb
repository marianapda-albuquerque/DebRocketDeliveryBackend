# frozen_string_literal: true

class Api::AuthController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  def index
    request_body = request.body
    resquest_header = request.headers
    create
    a = 3
  end
  
  # def new
  #   super
  # end

  def create
    super
  end

  def destroy
    super
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
