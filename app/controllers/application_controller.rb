class ApplicationController < ActionController::Base
  alias_method :current_user, :current_employee
  protect_from_forgery with: :exception
  before_action :authenticate_employee!
  before_action :configure_devise_permitted_parameters, if: :devise_controller?



  protected

  CONST_CREATE = 'create'.freeze
  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation, :role, :department_id, company_attributes: [:name, :description]]
    if params[:action] == CONST_CREATE
      devise_parameter_sanitizer.for(:sign_up) do |parameters|
        parameters.permit(registration_params)
      end
    end
  end
end
