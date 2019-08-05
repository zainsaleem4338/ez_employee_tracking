class ReportsController < ApplicationController  
  def show
    @employee_tasks_data = Report.compute_employees_velocity(current_employee)
  end

  def pdf_velocity_report
    @employee_tasks_data = Report.compute_employees_velocity(current_employee)
    binding.pry
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
end
