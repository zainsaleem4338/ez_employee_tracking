require 'date'
class AttendancesController < ApplicationController
  load_and_authorize_resource through: :current_employee, except: :show

  # GET    /employees/:employee_id/attendances
  def index
    @attendances = @attendances.paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
    end
  end

  # get /attendances
  def show_employee_attendance
    @attendances = current_employee.company.employees.find_by(sequence_num: current_employee.sequence_num).attendances.paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
    end
  end

  # POST   /employees/:employee_id/attendances
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

      @attendance.login_time = DateTime.now
      @attendance.status = 1
      if @attendance.save
        flash[:success] = t('.success_notice')
      else
        flash[:danger] = t('.error_notice')
      end
    end
    respond_to do |format|
      format.js
    end
  end

  # PATCH  /employees/:employee_id/attendances/:id
  def update
    if @attendance.update_attribute('logout_time',DateTime.now)
      flash[:success] = t('.success_notice')
    else
      flash[:danger] = t('.error_notice')
    end

    respond_to do |format|
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
