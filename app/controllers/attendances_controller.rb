require 'date'
class AttendancesController < ApplicationController
  def index
    @attendances_list = current_employee.all_attendances
  end

  def create
    @employees_todays_attendance = current_employee.todays_attendance_of_employee
    if @employees_todays_attendance.blank?
      @employee_attendance = current_employee.company.attendances.create(login_time: DateTime.now, status: Attendance::STATUS[:PRESENT], employee_id: current_employee.id)
      if @employee_attendance.valid?
        flash[:success] = 'Checked in successfully!'
      else
        flash[:danger] = 'Check in failed!'
        return false
      end
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
      if @result
        flash[:success] = 'Checked out successfully!'
      else
        flash[:danger] = 'Check out failed!'
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
