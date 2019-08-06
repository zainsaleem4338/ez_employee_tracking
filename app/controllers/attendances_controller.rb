require 'date'
class AttendancesController < ApplicationController
  def index
    @attendances_list = current_employee.all_attendances
  end

  def create
    @employees_todays_attendance = current_employee.todays_attendance_of_employee
    if @employees_todays_attendance.blank?
      setting = current_employee.company.setting
      today_start_time = setting.timings[Time.now.strftime('%A').downcase + '_start_time']
      attendance_thresh = setting.attendance_time
      attendance_thresh = 0 if attendance_thresh.nil?
      if get_time_in_seconds(Time.now) > get_time_in_seconds(today_start_time.to_time) + attendance_thresh * 60
        if current_employee.late_count.nil?
          current_employee.late_count = 0
        end
        current_employee.late_count = current_employee.late_count + 1
        current_employee.save
      end
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

  protected

  def get_time_in_seconds(time)
    hours_in_seconds = time.strftime('%H').to_i * 3600
    minutes_in_seconds = time.strftime('%H').to_i * 60
    hours_in_seconds + minutes_in_seconds
  end
end
