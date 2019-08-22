require 'date'
class AttendancesController < ApplicationController
  load_and_authorize_resource through: :current_employee

  # GET    /employees/:employee_id/attendances
  def index
    @attendances = @attendances.order(login_time: :desc).paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
    end
  end

  # GET    /employee/:employee_id/my_attendance
  def show_employee_attendance
    @attendances = current_employee.attendances.paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
    end
  end

  # POST   /employees/:employee_id/attendances
  def create
    current_employee.company.attendances.transaction do
      @attendance.login_time = DateTime.now
      @attendance.status = 1
      @attendance.save
      current_employee.late_count_of_employee
      current_employee.save
    end
    if @attendance.valid?
      flash[:success] = t('.success_notice')
    else
      flash[:danger] = t('.error_notice')
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

end
