require 'date'
class ReportsController < ApplicationController
  protect_from_forgery except: :load_task_data_in_report

  # get /reports/task_report
  def task_report
    @tasks = current_employee.company.tasks.paginate(page: params[:page], per_page: 5)
  end

  # get /reports/load_task_data_in_report
  def load_task_data_in_report
    task_hash = Report.get_task_query_hash(params[:project], params[:status], params[:created_start], params[:created_end], params[:deadline_start], params[:deadline_end])
    @tasks = current_employee.company.tasks.where(task_hash).paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js
    end
  end

  # get /reports/task_pdf_csv_report
  def task_pdf_csv_report
    task_hash = Report.get_task_query_hash(params[:project], params[:status], params[:created_start], params[:created_end], params[:deadline_start], params[:deadline_end])
    @tasks = current_employee.company.tasks.where(task_hash)
    if params[:pdf]
      @pagination_disallow = 0
      request.format = :pdf
    elsif params[:csv]
      request.format = :csv
    end
    respond_to do |format|
      format.csv do
        send_data Report.to_csv(@tasks), filename: "task-#{Time.zone.now.to_datetime}.csv"
      end
      format.pdf do
        render pdf: 'Tasks',
          template: 'reports/task_pdf_report.html.erb',
          layout: 'pdf.html',
          page_size: 'A4',
          dpi: 55
      end
    end
  end

  # get /reports/velocity
  def show
    @employee_tasks_data = Report.compute_employees_velocity(current_employee)
    # @employee_tasks_data = @employee_tasks_data.paginate(page: params[:page], per_page: 5)
  end

  # get /reports/export_report
  def pdf_velocity_report
    @employee_tasks_data = Report.compute_employees_velocity(current_employee)
    respond_to do |format|
      format.pdf do
        render pdf: 'Employees Velocity',
          template: 'reports/employee_velocity_pdf_report.html.erb',
          layout: 'pdf.html',
          page_size: 'A4',
          dpi: 55
      end
    end
  end

  # get /employees_attendance_report
  def attendance_report
    if current_employee.role == Employee::ADMIN_ROLE
      @attendances = Report.attendance_data(current_employee).paginate(page: params[:page], per_page: 10)
    end
  end

  def single_team_tasks
    @team_members_data = Report.single_team_velocity(current_employee,params[:team_id])
    respond_to do |format|
      format.js
    end
  end

  # get /employees_report_pdf
  def attendance_report_pdf
    if current_employee.role == Employee::ADMIN_ROLE
      @attendances = Report.attendance_data(current_employee)
      respond_to do |format|
        format.pdf do
          render pdf: 'Attendance Report',
            template: 'reports/_attendance_report_grid.html.erb',
            layout: 'pdf.html',
            page_size: 'A4',
            dpi: 55
        end
      end
    end
  end
end
