class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_employee!
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation, :role, :department_id, company_attributes: [:name, :description]]

    if params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(registration_params)
      end
    end
  end
end
