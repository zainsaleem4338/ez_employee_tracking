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
      setting = Setting.all.first
      today_start_time = setting.timings[Time.now.strftime('%A').downcase + '_start_time']
      attendance_thresh = setting.attendance_time
      if get_time_in_seconds(Time.now) > get_time_in_seconds(today_start_time.to_time) + attendance_thresh * 60
        if current_employee.late_count.nil?
          current_employee.late_count = 0
        end
        current_employee.late_count = current_employee.late_count + 1
        current_employee.save
      end
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

  protected

  def get_time_in_seconds(time)
    hours_in_seconds = time.strftime('%H').to_i * 3600
    minutes_in_seconds = time.strftime('%H').to_i * 60
    hours_in_seconds + minutes_in_seconds
  end
end
