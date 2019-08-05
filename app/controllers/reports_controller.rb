class ReportsController < ApplicationController

  def show
    @employee_tasks_data = Report.compute_employees_velocity(current_employee)
  end

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

  def attendance_report
    if current_employee.role == Employee::ADMIN_ROLE
      @attendances = Report.attendance_data(current_employee).paginate(page: params[:page], per_page: 10)
    end
  end

  def attendance_report_pdf
    if current_employee.role == Employee::ADMIN_ROLE
      @attendances = Report.attendance_data(current_employee)
      Report.upload_worksheet(@attendances, "attendance_data", get_session)
      binding.pry
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
