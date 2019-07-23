class EmployeesController < ApplicationController

  def index
    @employees = current_employee.company.employees.active_members
  end

  def new
    @employee = current_employee.company.employees.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      flash.now[:success] = 'Employee successfully created!'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    @employee = current_employee.company.employees.find_by(sequence_num: params[:id])
    @employee.active = false
    flash[:danger] = 'Employee is now inactive!'
    if @employee.save
      redirect_to employees_path
    else
      redirect_to root_path
    end
  end

  def after_signin
    @employee = Employee.find_by(email: params[:email])
    if @employee.nil?
      render 'signin'
    else
      redirect_to projects_page_url(@employee)
    end
  end

  def employees_list
    @employees = Employee.order(:email)
    respond_to do |format|
      format.json { render json: Employee.where('role != ? AND name like ?', 'admin',"%#{params[:q]}%" ) }
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :email, :password, :role, :company_id, :department_id)
  end
end
