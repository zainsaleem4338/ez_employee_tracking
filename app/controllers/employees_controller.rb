class EmployeesController < ApplicationController  
  load_and_authorize_resource :employee, through_association: :company

  def employees_lists
    respond_to do |format|
      format.json { render json: @employees.where('role != ? AND name like ?', Employee::ADMIN_ROLE, "%#{params[:q]}%") }
    end
  end

  def show
    @attendances_list = current_employee.all_attendances
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
