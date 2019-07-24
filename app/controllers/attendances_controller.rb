require 'date'
# Public
# Controls the attendance of employees
# It does the following tasks:
#   - Mark attendance of a employee/ Employee
#   - Let admin see who is present today
class AttendancesController < ApplicationController
  include EmployeesHelper
  STATUS = { 'PRESENT': 1, 'ABSENT': 0 }.freeze

  def index
    @company = Company.find(current_employee.company_id)
    @attendances_list = @company.attendances.where(status: STATUS[:PRESENT]).order(login_time: :desc)
  end

  def create
    @company = Company.find(current_employee.company_id)
    @employees_todays_attendance = current_employee.todays_attendance_of_employee(@company)
    
    if @employees_todays_attendance.blank?
      @employee_attendance = @company.attendances.create(login_time: DateTime.now, status: STATUS[:PRESENT], employee_id: current_employee.id)
      return false unless @employee_attendance.valid?
    end

    respond_to do |format|
      format.html 
      format.js
    end
  end

  def update
    @company = Company.find(current_employee.company_id)
    @employees_todays_attendance = current_employee.todays_attendance_of_employee(@company)
    
    unless @employees_todays_attendance.blank?
      @employee_attendance = @company.attendances.find_by(employee_id: @current_employee.id)
      @employee_attendance.logout_time = DateTime.now
      @employee_attendance.save!
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end