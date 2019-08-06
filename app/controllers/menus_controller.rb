class MenusController < ApplicationController
  skip_before_action :authenticate_employee!, only: [:home, :search_email]

  def index
    @events = current_employee.company.events
    @settings = current_employee.company.setting
    @setting = @settings.holidays
    @working_days = @settings.working_days
    if current_employee.late_count.nil?
      @late_count = nil
    else
      @late_count = current_employee.late_count 
    end
  end

  def home
    if current_employee.present?
      redirect_to menus_index_path
    end
  end
  
  def search_email
    @email = params[:email]
    if(@email.present?)
      employees = Employee.where(email: params[:email])
      @companies = []
      employees.each do |employee|
        company = Company.find_by(id: employee.company_id)
        @companies.push(company)
      end
    end
    respond_to do |format|
      format.js
    end
  end
end
