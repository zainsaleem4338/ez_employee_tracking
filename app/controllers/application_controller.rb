class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_employee!
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

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

  def current_company
    Company.find_by_subdomain request.subdomain
  end
  helper_method :current_company
end
