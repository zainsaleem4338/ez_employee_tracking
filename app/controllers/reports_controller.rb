class ReportsController < ApplicationController

  def attendance_report
    if current_employee.role == Employee::ADMIN_ROLE
      @attendances = Report.attendance_data(current_employee).paginate(page: params[:page], per_page: 10)
    end
  end

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
