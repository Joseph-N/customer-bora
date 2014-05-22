class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :"birthday(3i)", :"birthday(2i)", :"birthday(1i)",
                                                            :location, :email, :password, :phone,:password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:phone, :password) }
  end

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end
end
