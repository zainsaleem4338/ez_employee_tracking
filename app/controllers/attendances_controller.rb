require 'date'
# Public
# Controls the attendance of employees
# It does the following tasks:
#   - Mark attendance of a employee/ Employee
#   - Let admin see who is present today
class AttendancesController < ApplicationController
  def index
    @company = Company.find(session[:current_company_id])
    @attendances_list = @company.attendances.where(status: 1).order(login_time: :desc)
  end

  def create
    @current_employee = Employee.find(session[:current_employee_id])
    @company = Company.find(session[:current_company_id])
    @employees_todays_attendance = @current_employee.todays_attendance_of_employee(@company)
    
    if @employees_todays_attendance.nil?
      @employee_attendance = @company.attendances.create(login_time: DateTime.now, status: 1, employee_id: session[:current_employee_id])
      return false unless @employee_attendance.valid?
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @current_employee = Employee.find(session[:current_employee_id])
    @company = Company.find(session[:current_company_id])
    @employees_todays_attendance = @current_employee.todays_attendance_of_employee(@company)
    
    unless @employees_todays_attendance.nil?
      @employee_attendance = @company.attendances.find_by(employee_id: @current_employee.id)
      @employee_attendance.logout_time = DateTime.now
      @employee_attendance.save
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:id)
  end

  def pre_create_update_computation
    # add employee and company object creation
  end
end
