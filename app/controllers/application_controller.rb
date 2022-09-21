class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: %i[index show]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username birth_date first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username birth_date first_name last_name])
  end
end
