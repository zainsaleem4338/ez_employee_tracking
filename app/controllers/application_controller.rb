class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_employee!
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter :set_cache_buster

  protected

  CONST_CREATE = 'create'.freeze
  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation, :role, :department_id, company_attributes: [:name, :description, :subdomain]]
    if params[:action] == CONST_CREATE
      devise_parameter_sanitizer.for(:sign_up) do |parameters|
        parameters.permit(registration_params)
      end
    end
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def current_company
    Company.find_by_subdomain request.subdomain
  end
  helper_method :current_company
end
