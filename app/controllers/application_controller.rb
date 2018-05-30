
# Application Controller
class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  before_action :sanitize_devise_parameters, if: :devise_controller?

  def sanitize_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation,:first_name,:last_name,:birthday, :gender, :short_description, :avatar,:country])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation,:first_name,:last_name,:birthday, :gender, :short_description, :avatar,:country])
  end



end