class EmployeesController < ApplicationController
  STATUS = { 'PRESENT': 1, 'ABSENT': 0 }.freeze
  load_and_authorize_resource :employee, through_association: :company

  def employees_lists
    respond_to do |format|
      format.json { render json: @employees.where('role != ? AND name like ?', Employee::ADMIN_ROLE, "%#{params[:q]}%") }
    end
  end

  def show
    @attendances_list = current_employee.company.attendances.where(status: STATUS[:PRESENT]).order(login_time: :desc)
    
    @employee_tasks, @employee_velocity = current_employee.compute_employees_velocity
  end

  def create
    if @employee.save
      flash.now[:success] = 'Employee successfully created!'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    @employee = current_employee.company.employees
                                .find_by(sequence_num: params[:id])
    @employee.active = false
    flash[:danger] = 'Employee is now inactive!'
    if @employee.save
      redirect_to employees_path
    else
      redirect_to root_path
    end
  end

  def pdf_velocity_report
    @employee_tasks, @employee_velocity = current_employee.compute_employees_velocity
    respond_to do |format|
      format.pdf do
        render pdf: 'Employees Velocity',
        template: 'employees/employee_velocity_pdf_report.html.erb',
        layout: 'pdf.html',
        page_size: 'A4',
        dpi: 55
      end
    end
  end

  def pdf_team_velocity_report
    @employee_tasks, @employee_velocity = current_employee.compute_employees_velocity
    respond_to do |format|
      format.pdf do
        render pdf: 'Team Velocity',
        template: 'employees/team_velocity_pdf_report.html.erb',
        layout: 'pdf.html',
        page_size: 'A4',
        dpi: 55
      end
    end
  end

  private

  def employee_params
    params.require(:employee)
          .permit(:name, :email, :password, :role, :company_id, :department_id)
  end  
end
