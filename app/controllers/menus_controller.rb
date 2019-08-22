class MenusController < ApplicationController
  skip_before_action :authenticate_employee!, only: [:home, :search_email, :page_not_found]

  # get 'menus/index'
  def index
    @events = current_employee.company.events
    @settings = current_employee.company.setting
    if(@settings.working_days.class == String)
      @settings.working_days = JSON.parse(@settings.working_days.gsub("'",'"').gsub('=>',':'))
      @settings.timings = JSON.parse(@settings.timings.gsub("'",'"').gsub('=>',':'))
    end
    @setting = @settings.holidays
    @working_days = @settings.working_days
    leaves_remaining = Report.attendance_data(current_employee, false)
    @leaves_remaining = leaves_remaining
    if current_employee.late_count.nil?
      @late_count = nil
    else
      @late_count = current_employee.late_count
    end
    respond_to do |format|
      format.html
    end
  end

  # get 'menus/home'
  def home
    if current_employee.present?
      redirect_to menus_index_path
    end
  end

  # post 'menus/search_email'
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
      format.html
    end
  end

  def page_not_found
    render 'page_not_found', layout: false
  end
end
