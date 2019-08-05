class EmployeesController < ApplicationController
  
  load_and_authorize_resource :employee, through_association: :company

  def employees_lists
    respond_to do |format|
      format.json { render json: @employees.where('role != ? AND name like ?', Employee::ADMIN_ROLE, "%#{params[:q]}%") }
    end
  end

  def show
    @attendances_list = current_employee.company.attendances.where(status: Attendance::STATUS[:PRESENT]).order(login_time: :desc)
    
    @employee_tasks_data = current_employee.compute_employees_velocity
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.password = generate_password
    if @employee.save
      flash[:success] = 'Employee successfully created!'
      redirect_to menus_index_path
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
      redirect_to menus_index_path
    end
  end

  def pdf_velocity_report
    @employee_tasks_data = current_employee.compute_employees_velocity
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

  private

  def employee_params
    params.require(:employee)
          .permit(:name, :email, :password, :role, :company_id, :department_id)
  end

  def generate_password
    random_password = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...10).map { random_password[rand(random_password.length)] }.join
  end
end
