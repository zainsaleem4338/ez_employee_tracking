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
    @attendances_list = current_employee.company.attendances.where(status: STATUS[:PRESENT]).order(login_time: :desc)
  end

  def create
    @employees_todays_attendance = current_employee.todays_attendance_of_employee
    if @employees_todays_attendance.blank?
      @employee_attendance = current_employee.company.attendances.create(login_time: DateTime.now, status: STATUS[:PRESENT], employee_id: current_employee.id)
      return false unless @employee_attendance.valid?
    end

    respond_to do |format|
      format.html 
      format.js
    end
  end

  def update
    @employees_todays_attendance = current_employee.todays_attendance_of_employee

    unless @employees_todays_attendance.blank?
      @employees_todays_attendance.logout_time = DateTime.now
      @result = @employees_todays_attendance.save!
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
