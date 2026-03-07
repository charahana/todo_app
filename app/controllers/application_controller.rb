class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    about_path
  end

  def after_sign_out_path_for(resource)
    about_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def current_organization
    return nil unless user_signed_in?
    @current_organization ||= begin
      if session[:organization_id]
        current_user.organizations.find_by(id: session[:organization_id])
      else
        current_user.organizations.first
      end
    end
  end
  helper_method :current_organization
end
