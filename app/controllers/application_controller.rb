require 'will_paginate/array'

class ApplicationController < ActionController::Base
  alias_method :current_user, :current_employee
  protect_from_forgery with: :exception
  before_action :authenticate_employee!
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter :set_cache_buster
  around_filter :scope_current_company
 
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html {
        flash[:danger] = 'You are not authorized to perform such action'
        redirect_to main_app.root_url
      }
      format.js { head :forbidden, content_type: 'text/html' }
    end
  end

  protected

  CONST_CREATE = 'create'.freeze
  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation, :role, :department_id,
    company_attributes: [:name, :description, :subdomain, setting_attributes: [:working_days, :timings, :holidays, :task_alert]],
   ]
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

  def scope_current_company
    Company.current_id = current_company.id unless current_company.nil?
    yield
  ensure
    Company.current_id = nil
  end

  private
  def after_sign_out_path_for(resource_or_scope)
    root_url(subdomain: false)
  end

end
